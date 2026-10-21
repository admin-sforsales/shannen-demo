import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // NEXT_DIST_DIR sert au build de vérification local (hook Claude Code) pour ne pas écraser le .next du serveur de dev.
  distDir: process.env.NEXT_DIST_DIR || ".next",
};

export default nextConfig;
