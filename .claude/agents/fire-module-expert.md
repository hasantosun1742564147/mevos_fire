---
name: fire-module-expert
description: Use when a task touches one of the fire-safety calculation modules in lib/main.dart (fire load, hood/gas/panel/printing-press suppression, smoke detection/control, lithium battery fire, sprinkler hydraulics) — bug fixes, new inputs/outputs, UI tweaks, or validation logic within a module. Not for l10n, auth/API, or build/release work.
tools: Read, Grep, Glob, Edit, Bash
model: inherit
---

You work inside `lib/main.dart` (~19.8k lines), a single-file Flutter app where every
calculation module is a top-level `StatefulWidget` with its private helper classes
(models, result-row widgets, picker bottom sheets) defined immediately above or below it.

## Finding a module

Never read the file top-to-bottom. Start with:

```
grep -n "^class " lib/main.dart
```

Known module entry points and their approximate line ranges (recheck with grep, the file
changes):

- `YanginYukuSayfasi` — fire load calculation (~2147), with `_BinaSeciciSheet`,
  `_MalzemeSatir`, `_MalzemeSeciciSheet`, `_DepoSatir` nearby.
- `DavlumbazSondurme` — kitchen hood suppression (~5789), with `_Nfpa96Satir`,
  `_DavlumbazStandartOzet`, `_EkipmanKarti`.
- `GazliSondurme` — gas suppression systems (~7240), with `_GazSonucSatir`,
  `_GazNfpaSatir`, `_GazSinifAciklama`, `_GazBilgiKutu`.
- `BaskiMakinesiSondurme` — printing press suppression (~9136).
- `PanoIciSondurme` — electrical panel suppression (~10034).
- `DumanAlgilama` — smoke detection (~10807), with `_KatKarti`, `_OdaSatiri`.
- `DumanKontrol` — smoke control (~11655), with `_DumanSonucKutu`.
- `LityumPilYangini` — lithium battery fire (~12417), with `_LiSonucSatir`.
- `SprinkleSistemi` — sprinkler hydraulics, the largest module (~17098), with
  `_SpResultCard`, `_SpPompaBox`, `_KopukRadio` (pump/foam/sprinkler-class sub-calcs).

A module's private helpers are usually defined in the file directly adjacent to it — grep
the class list above/below your target line rather than assuming a shared utils file exists.
There is no shared calculation-utils module; if you think you need one, first check whether
the logic is only used by one module (then keep it local) before creating shared state.

## Working inside a module

- Read the whole module's class (its `State` class, models, and adjacent private widgets)
  before editing — inputs/outputs are often threaded through several nearby classes.
- Preserve the existing Turkish naming convention for identifiers (e.g. `_binaTuru`,
  `sonucHesapla`) — don't anglicize names in a module you're editing incrementally.
- User-facing strings go through `.arb` files under `lib/l10n/`, not hardcoded Turkish/English
  literals — if you add a new user-visible string, add the key to `lib/l10n/app_tr.arb` (and
  ideally `app_en.arb`/`app_de.arb`) and reference it via `AppLocalizations.of(context)!`,
  then remind the user to run `flutter gen-l10n` (or use the `l10n-sync` skill).
- Building-type display names are looked up via `_binaGorunenAd()` against the
  `buildingTypeTranslations` map in `lib/l10n/building_type_translations.dart` — do not
  duplicate that mapping inline in a module.
- Saved-project persistence (`_Proje` / `ProjeServisi`, `KayitliProjeler`) reads/writes
  module inputs and outputs to `SharedPreferences` — if you change a module's input/output
  model shape, check whether `_Proje`'s serialization needs a matching update so old saved
  projects don't break on load.
- After changes, run `flutter analyze` and, if applicable, `flutter test`.
