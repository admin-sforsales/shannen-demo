#!/bin/bash
# Hook Stop de Claude Code : avant que Claude rende la main, vérifie que le build passe.
# - Ne rebuild que si le code a changé depuis le dernier build réussi (empreinte HEAD + diff + fichiers non suivis, hors .md et .claude/).
# - Build en échec : exit 2, Claude reçoit la fin du journal et doit corriger avant de s'arrêter.
# - Après 3 échecs d'affilée, laisse Claude s'arrêter et prévient l'utilisateur, pour ne pas boucler.

cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}" || exit 0
ETAT=.claude/.verif-build-etat
MAX_ECHECS=3

# Commande de build propre à ce dépôt (remplacée à l'installation).
build() {
  NEXT_DIST_DIR=.next-verif \
    NEXT_PUBLIC_SUPABASE_URL="${NEXT_PUBLIC_SUPABASE_URL:-https://placeholder.supabase.co}" \
    NEXT_PUBLIC_SUPABASE_ANON_KEY="${NEXT_PUBLIC_SUPABASE_ANON_KEY:-placeholder-anon-key}" \
    SUPABASE_SERVICE_ROLE_KEY="${SUPABASE_SERVICE_ROLE_KEY:-placeholder-service-key}" \
    npm run build
  # Valeurs Supabase factices : le build vérifie la compilation, il n'appelle pas la base.
}

empreinte=$(
  {
    git rev-parse HEAD 2>/dev/null
    git diff HEAD -- . ':(exclude)*.md' ':(exclude).claude/' 2>/dev/null
    git ls-files --others --exclude-standard -z -- . ':(exclude)*.md' ':(exclude).claude/' 2>/dev/null | xargs -0 shasum 2>/dev/null
  } | shasum | cut -d' ' -f1
)

if [ ! -d node_modules ]; then
  echo '{"systemMessage": "Vérification du build sautée : node_modules absent (npm install à lancer dans ce dossier)."}'
  exit 0
fi

derniere_ok=""; echecs=0
[ -f "$ETAT" ] && . "$ETAT"
if [ "$empreinte" = "$derniere_ok" ]; then
  [ "$echecs" != 0 ] && printf 'derniere_ok=%s\nechecs=0\n' "$derniere_ok" > "$ETAT"
  exit 0
fi

journal=$(mktemp)
export NO_COLOR=1 FORCE_COLOR=0
if build >"$journal" 2>&1; then
  printf 'derniere_ok=%s\nechecs=0\n' "$empreinte" > "$ETAT"
  rm -f "$journal"
  exit 0
fi

echecs=$((echecs + 1))
printf 'derniere_ok=%s\nechecs=%s\n' "$derniere_ok" "$echecs" > "$ETAT"
if [ "$echecs" -ge "$MAX_ECHECS" ]; then
  printf '{"systemMessage": "Build toujours en échec après %s tentatives : vérification abandonnée, à regarder à la main."}\n' "$echecs"
  printf 'derniere_ok=%s\nechecs=0\n' "$derniere_ok" > "$ETAT"
  rm -f "$journal"
  exit 0
fi

{
  echo "Le build échoue (tentative $echecs/$MAX_ECHECS). Corrige avant de rendre la main. Fin du journal :"
  sed -E 's/\x1b\[[0-9;]*m//g' "$journal" | grep -E 'rror|failed|✖|✗' | head -15
  echo "---"
  sed -E 's/\x1b\[[0-9;]*m//g' "$journal" | tail -30
} >&2
rm -f "$journal"
exit 2
