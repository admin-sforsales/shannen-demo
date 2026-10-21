# Roadmap — Hello Michel

Backlog remis à plat le 21/10/2026, contre le code et `git log` (dernier commit vérifié : `2525e2d`).
À relire en début de session, à mettre à jour en fin de tâche.

**Dépôt public** : ce fichier ne contient ni faille non corrigée, ni secret, ni adresse, ni nom d'élève.
Le détail est dans la fiche projet hors dépôt (`SforSales/Projets/Hello Michel/`).

Sources entre parenthèses : `_contexte-hello-michel.md` (« contexte »), la note sécurité du 19/10 (« plan sécurité »),
`AUDIT.md` et `mission1_neocell.md` (« mission 1 ») de ce dépôt.

Marques : **[Shannen]** attend une décision de Shannen · **[Vincent]** attend une décision de Vincent ·
sans marque = tranché, prêt à faire.

## À faire

### 1. Fin de la reprise (sécurité et accès)

- [ ] Appliquer les étapes 2 à 4 du plan sécurité du 19/10 (droits de la base et du stockage, puis code) ; détail hors dépôt, à faire hors séance de formation **[Vincent]** (contexte « Reste à faire » 0, plan sécurité)
- [ ] Mode d'inscription des élèves : libre, avec confirmation d'email, ou sur invitation **[Shannen]** (plan sécurité)
- [ ] Supprimer les comptes de test de l'ancienne agence dans l'app (efface aussi leurs simulations de test) **[Vincent]** (plan sécurité)
- [ ] Renouveler les clés Supabase d'avant la reprise, les remplacer dans Vercel, redéployer, retester connexion et simulation ; coupe les sessions, donc hors séance (contexte « Reste à faire » 1)
- [ ] Clé Anthropic : vérifier dans la console SforSales qu'elle est à nous, sinon en créer une et prévenir l'agence (contexte « Reste à faire » 2)
- [ ] Retirer de Vercel les 4 variables AWS (encore là le 21/10, plus lues par le code) et désactiver la clé IAM si le compte AWS est à nous (contexte « Reste à faire » 3, mission 1 « Nettoyage AWS »)
- [ ] Passer `ELEVENLABS_API_KEY` et `ANTHROPIC_API_KEY` en type sensitive (encore « encrypted », donc relisibles dans Vercel, le 21/10) (contexte « Reste à faire » 4)
- [ ] Passer le dépôt en privé, puis vérifier que Vercel déploie toujours **[Vincent]** (contexte « Reste à faire » 5)
- [ ] Fermer les PR de l'agence encore ouvertes : #1 « phone-test », #4 « Profil utilisateur » (contexte « Reste à faire » 6)
- [ ] Supprimer la clé Resend inutilisée « Claude Vincent » (contexte « Reste à faire » 7)
- [ ] Envoyer le mail de fin de passation à l'agence (brouillon dans la fiche projet du 19/10) **[Vincent]** (contexte « Reste à faire » 8)

### 2. Tests et rattrapages

- [ ] Parcours « mot de passe oublié » complet en prod : jamais testé (mission 1, point 5b)
- [ ] Lancer une fois `/api/cron/repair-feedbacks` (route de rattrapage des feedbacks dégradés, hors `vercel.json`) et contrôler le résultat **[Vincent]** (contexte « Tâches planifiées »)
- [ ] Résumés des anciennes conversations (852 sans résumé en avril, invisibles dans « Reprendre l'historique ») : les générer après coup ou non **[Shannen]** (mission 1 « À demander à Shannen »)

### 3. Produit

- [ ] Page de progression pour l'élève : score moyen, courbe, points forts et axes récurrents (l'admin l'a déjà, pas l'élève) **[Shannen]** (AUDIT suggestion 5)
- [ ] Une seule simulation à la fois par élève (statut de conversation, déblocage après la durée max) (AUDIT suggestion 7)
- [ ] Prospects sans description détaillée : répliques génériques répétées, phrases d'exemple du prompt reprises mot pour mot (mission 1 « Remarques techniques »)
- [ ] Bouton « Générer avec l'IA » pour la description d'un prospect (mission 1 « Suggestions UX »)
- [ ] Raccourcis « Créer un prospect » et « Créer un produit » dans l'assistant de configuration (mission 1 « Suggestions UX »)
- [ ] Table `app_settings` (consignes du prospect modifiables par un admin) : en base, lue par aucun code ; la brancher ou la supprimer **[Vincent]** (contexte « Données »)
- [ ] Colonne `users.credits` inutilisée : quota par élève ou suppression **[Shannen]** (AUDIT « Questions en suspens » 2)
- [ ] Durées proposées (30, 45, 60 min) et durée par défaut **[Shannen]** (AUDIT « Questions en suspens » 1)

### 4. Coût ElevenLabs

- [ ] Réglages voix `stability` 0,5 → 0,3 et `similarity_boost` 0,8 → 0,6 (`app/api/simulation/start/route.ts:149` et `:409`), réversibles **[Vincent]** (AUDIT suggestion 4)
- [ ] Séparer la partie fixe du prompt de la partie variable (AUDIT suggestion « Optimisation du prompt »)
- [ ] Lancer `simulation/start` et `get-signed-url` en parallèle au démarrage (~500 ms) (AUDIT suggestion 9)

### 5. Nettoyage

- [ ] Supprimer le code mort : `app/api/elevenlabs/manage-agent` et `app/api/simulation/end` (sans `[id]`) (contexte « Code mort », AUDIT suggestion 10)
- [ ] Remettre `database_schema.sql` d'aplomb depuis la vraie base, il est en retard (contexte « Architecture »)
- [ ] Docs périmées ou propres à l'agence : `SIMULATION_SYSTEM_README.md`, `mission1_neocell.md` (parle encore de Haiku 3), `AUDIT.md`, PDF, `proposal/`, `report_preview/`, scripts `generate_pdf*.py` : mettre à jour, archiver hors dépôt ou supprimer **[Vincent]** (contexte « Architecture », « Code mort »)
- [ ] Retirer `package-lock.json` : c'est pnpm qui fait foi (contexte « Travailler en local »)

## Fait

### Reprise par SforSales (19 au 21/10/2026)

- [x] Vérification automatique du build en fin de tâche Claude Code (`2525e2d`)
- [x] Dépôt GitHub relié au projet Vercel de l'équipe SforSales ; cron des alertes réenregistré (contexte « Reprise du 19/10 »)
- [x] Alertes de crédits ElevenLabs envoyées par le Resend SforSales, domaine `notifications.sforsales.academy`, nouveau `CRON_SECRET` (contexte « Reprise du 19/10 »)
- [x] Accès de l'agence retirés : collaborateurs GitHub, membre Supabase, statut admin dans l'app (contexte « Reprise du 19/10 », plan sécurité étape 1)
- [x] Connexion et simulation testées après la reprise, aucune erreur dans les logs (contexte « Reprise du 19/10 »)

### Agence Neocell (avril à octobre 2026)

- [x] Correctifs d'octobre : feedback en sortie structurée, une seule fin d'appel et un seul feedback par simulation, plus de réponses sans paroles, alerte de plafond ElevenLabs, route de rattrapage des feedbacks (`43c6cba`, `24086bf`, `17132cb`, `8d29770`, `a4a0d81`)
- [x] Limite de 90 simulations par mois, remise à zéro le 1er (`35144c2`)
- [x] Espace admin : suivi des élèves, rôle `is_admin` (`3453a7a`)
- [x] Quatre niveaux de difficulté, prompt découpé par type d'appel (`0041dce`, `b111766`, `bef2e41`)
- [x] Mission 1 : historique entre conversations (résumés), durée d'appel configurable avec minuteur, passage de Bedrock à l'API Anthropic, vrai identifiant de conversation ElevenLabs, page Profil, prompt du prospect renforcé (mission 1 « État d'avancement »)

### Abandonné

- Limite de 3 simulations par jour, remplacée par 90 par mois (`35144c2`)
- Claude 3.7 Sonnet et Haiku 3 : remplacés par Haiku 4.5 (contexte « Architecture »)
