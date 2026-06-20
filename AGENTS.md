# Agent Instructions for Practice Coxing Commands

## What this repository is
- A Godot 3.5 game project for rowing coxing command training.
- The main game source is in `src/` and is written in GDScript.
- A lightweight Node/TypeScript server project lives in `Server/` for optional high scores, feedback, shared settings, and logging.

## Key conventions
- The Godot project is in `src/`. Do not open the `src/` folder in Godot with an import operation; the README warns this can corrupt images.
- The root `package.json` is used for release packaging and static web build output.
- The `template/` folder holds build-time HTML/JS/WASM assets that are copied into `bin/html/`.
- `bin/html/` contains the final published build.
- `Server/src/` contains the server-side code; it is built with TypeScript via `Server/package.json`.
- all the game texts are in the `src/translations/Translations.csv` these are exported from the numbers file `src/translations/Translations.numbers` when a text is changed both files must be changed. the Translations.csv must be inported into the godot game.
  
## Build / development commands
- Root frontend packaging:
  - `npm install`
  - export the Godot game from `src` in Godot
  - `npm run build`
- Optional release packaging with encrypted build:
  - `npm run build-encrypted`
- Server build:
  - `cd Server && npm install && npm run build`
- Full project Godot syntax check:
  - `npm run godot-check`
  - This runs Godot with `--check-only` on the whole `src` project and is configured to terminate automatically after a short timeout.

## Important file and secret notes
- `src/secrets.gd` and `Server/src/Secrets.json` are runtime secret configuration files and should not be committed with production secrets.
- The repo provides `src/secretsForGit.gd` / `Server/src/SecretsGit.json` as templates for git-safe values. Do not open, change these files. as they contain secrets
- The root scripts `prepare-build` and `prepare-git-commit` manage secret file swapping; treat them carefully.

## Agent behavior guidance
- When asked about gameplay, UI, or physics, start in `src/` and follow Godot scene/script structure.
- When asked about packaging, static deployment, or HTML/wasm build outputs, inspect `package.json`, `template/`, and `bin/html/`.
- When asked about server storage, high scores, or feedback, inspect `Server/` and `Server/README.md`.
- If a change may affect both client and server authentication, verify secret handling in both `src/secrets.gd` and `Server/src/Secrets.json`.

## Useful references
- Project README: [README.md](README.md)
- Server README: [Server/README.md](Server/README.md)

## What agents should avoid
- Do not add or commit actual secret values  `src/secrets.gd` , `Server/src/Secrets.json` and `src/export_presets.cfg`.
- Do not re-import or migrate the Godot project in `src/` unless explicitly instructed.
- Do not treat the repo as a standard web app only: the core application is a Godot game with a wrapper packaging layer.
