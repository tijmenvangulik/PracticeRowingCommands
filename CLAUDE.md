# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

The rules in AGENTS.md (secret files, translations, no Godot re-import) apply in full. This file adds the architecture notes.

## Commands

- `npm run godot-check`: GDScript syntax check of the whole `src/` project. This is the only automated check; the repo has no test suite or linter. Godot's path comes from `config.godotpath` in the root `package.json`.
- `npm run build`: headless export of the HTML5 preset to `bin/html`, then renders `template/index.html` and `template/version.json` with mustache (using `package.json` as data, so `version` flows into the page) and copies the JS loader.
- `npm run build-encrypted`: same, but uses the custom-built (encrypted) Godot wasm/js from `template/`.
- Server: `cd Server && npm run build` (or `npm run watch`). Uses MongoDB.
- Release version: bump `version` in the root `package.json`. Commit messages follow `<version> <description>`.
- Press F1 in the running game for debug mode.

## Architecture

**Engine:** Godot 3.5, GDScript 1, so use Godot 3 APIs (`connect("signal", self, "method")`, `yield`, `JavaScript` singleton, `export`). The only shipped target is HTML5.

**Single main scene:** `src/World.tscn` holds nearly everything: the boat, the river and world objects, all dialogs, and the control panel. Scripts usually reach other nodes through scene-unique names (`$"%Name"`) or relative paths, so moving nodes in `World.tscn` can break scripts silently.

**Autoload singletons** (see `[autoload]` in `src/project.godot`) carry the global state:
- `GameEvents` (`game_events.gd`): a signal bus for settings, language, commands, the collect game, the tour, and similar. Components talk through it instead of calling each other directly.
- `GameState`, `Settings`, `BaseSettings`: runtime state and persisted user settings.
- `Constants`: enums for commands, oar states, game states, and so on.
- `Utilities`: shared helpers, including `getDefaultSetting()`, which reads defaults from the translation file.
- `Practices`, `Styles`, `Languages`, `Secrets`, `CalcSecurityCode`.

**Boat simulation:** `Boat.gd` and `Oar.gd` drive the boat with Godot physics. When a command is issued, the active ruleset decides the boat's next state. `Rulesets.gd` picks a child node under `Boat/Rulesets` (`RulesetDefault`, `RulesetNoRules`), and each ruleset extends `BaseRuleset.gd`, overriding hooks such as `determinenewState` and `determineOarsState`. To add a ruleset, add a child node with a script that extends `BaseRuleset`.

**Text and configuration in translations:** `src/translations/Translations.csv` holds UI text and also config-like data: default button sets, the default ruleset, and per-command `_tooltip`, `_shorttooltip`, `_buttonOnly`, and `_shortcut` keys. Speech can switch voice per command with a `{{en-GB}}` tag inside the text. Dutch is the default language.

**Browser bridge:** GDScript calls browser JS through `JavaScript.eval(...)`, always guarded by `OS.has_feature('JavaScript')`. This covers speech (`speak`, `speakSupportsLanguage`), fullscreen, `localStorage`, URL parameters, settings import/export, and `appVersion`. Those JS functions live in `template/index.html`, which mustache renders to `bin/html/index.html`. Edit the template, not `bin/html`. The Godot-generated `index.js` is patched for a cache buster and virtual-keyboard hooks; see `patched.md`.

**Server (optional):** `Server/src/Server.ts` is an Express app with GET endpoints `/gameHighScores`, `/newGameHighScore`, `/sendFeedback`, `/logFinishedActivity`, `/saveSharedSetting`, and `/getSharedSetting`, backed by `RepositoryMongo.ts`. The client calls it through `HTTPRequest` nodes (`HighScores.gd`, `PublishHighscoreCollectGame.gd`, `FeedBackContainer.gd`, `LogActivity.gd`). Requests are signed with a hash from `CalcSecurityCode` and secrets that must match on both sides.

**Secret swapping:** `npm run prepare-build` copies the real secrets in and applies `template/patchExportSecret.patch` to `export_presets.cfg`. `npm run prepare-git-commit` restores the git-safe placeholders, rebuilds `distribute.zip`, and reverts the patch. Run `prepare-git-commit` before committing whenever `secrets.gd`, `Secrets.json`, or `export_presets.cfg` show as modified.
