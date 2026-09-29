---
name: l10n-sync
description: Use whenever adding, changing, or removing a user-facing string in lib/main.dart, or when the user asks to translate/localize something, add a new locale key, or check that Turkish/English/German strings are in sync. Covers editing the .arb sources, keeping building_type_translations.dart aligned, and regenerating app_localizations*.dart.
---

# Localization sync (tr/en/de)

This app's localization has two independent pieces that must both be kept in sync:

1. **Generated ARB-based strings** — `lib/l10n/app_tr.arb` (template, source of truth),
   `app_en.arb`, `app_de.arb`. These compile via `flutter gen-l10n` (config: `l10n.yaml`,
   `arb-dir: lib/l10n`, `template-arb-file: app_tr.arb`, `output-class: AppLocalizations`) into
   `lib/l10n/app_localizations*.dart`.
2. **Hand-maintained building-type map** — `lib/l10n/building_type_translations.dart`
   (`buildingTypeTranslations`), used via `_binaGorunenAd()` in `main.dart`. This is NOT part
   of the `.arb`/gen-l10n pipeline and is edited directly.

## Never hand-edit generated files

`app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_de.dart`, and
`app_localizations_tr.dart` are generated. Any edit there is silently discarded (or causes
diffs against source) the next time `flutter gen-l10n` runs. Always edit the `.arb` sources.

## Adding or changing a string

1. Add/edit the key in `lib/l10n/app_tr.arb` first (it's the template — key order and set
   define what other locales must provide).
2. Add the same key with translated values to `app_en.arb` and `app_de.arb`. Keep keys in the
   same relative position across all three files for easy diffing — don't append new keys only
   at the end of one file.
3. If the string takes placeholders (ICU/plural/gender), the `@key` metadata block (with
   `placeholders`) is only required in the template `app_tr.arb`; per Flutter's gen-l10n rules
   the translated files just need the matching `{placeholder}` tokens in the same positions.
4. Regenerate:
   ```
   flutter gen-l10n
   ```
5. Reference the string in `lib/main.dart` via `AppLocalizations.of(context)!.yourKey`, not a
   hardcoded literal.
6. Run `flutter analyze` — a missing/misspelled key or file surfaces there immediately.

## Building-type names

If the new/changed string is a building type shown via `_binaGorunenAd()`, update the map in
`lib/l10n/building_type_translations.dart` directly — do not add it to the `.arb` files, and do
not duplicate the mapping inline inside a calculation module.

## Checking sync / catching drift

There's no automated key-parity check in this repo. When asked to verify the three locales are
in sync, diff the key sets directly, e.g.:

```
grep -oE '"[a-zA-Z0-9_]+":' lib/l10n/app_tr.arb | sort -u > /tmp/tr_keys.txt
grep -oE '"[a-zA-Z0-9_]+":' lib/l10n/app_en.arb | sort -u > /tmp/en_keys.txt
grep -oE '"[a-zA-Z0-9_]+":' lib/l10n/app_de.arb | sort -u > /tmp/de_keys.txt
diff /tmp/tr_keys.txt /tmp/en_keys.txt
diff /tmp/tr_keys.txt /tmp/de_keys.txt
```
(`@`-prefixed metadata keys like `"@keyName":` will show up too — that's expected, they only
need to exist in the template file, so ignore metadata-only diffs against en/de.)

## `.bak` files

`lib/l10n/*.arb.bak` are stale backups left in the working tree, not part of the build. Don't
edit or rely on them; flag to the user if they seem to be shadowing intended changes, but don't
delete them without asking.
