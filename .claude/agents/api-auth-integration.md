---
name: api-auth-integration
description: Use for anything touching the mevos.com.tr backend integration in lib/main.dart — login/session flow, JWT token handling, permission/entitlement checks (perms map, fire/fire_activatedAt), demo mode gating, account deletion, or the Gemini AI chat integration. Not for calculation-module logic or l10n/build tasks.
tools: Read, Grep, Glob, Edit, Bash
model: inherit
---

You work on the network/auth layer of `lib/main.dart`. This app has no separate API client
module — all HTTP calls are inline `http.get`/`http.post` calls scattered through the relevant
screen widgets. Find call sites with:

```
grep -n "kApiBase\|http\.\(get\|post\)" lib/main.dart
```

## Key facts

- `kApiBase = 'https://www.mevos.com.tr'` (top of file, ~line 207) is the only base URL
  constant — never hardcode the domain elsewhere.
- Auth/account endpoints live under `/api/auth/*.php`: `login.php`, `me.php`,
  `delete-account.php`. A separate top-level endpoint, `/api/fire_version.php`, is polled for
  update checks against `kAppVersion`.
- Session token is stored in `SharedPreferences` under the key `jwt_token` and sent as
  `Authorization: Bearer $token`. Always clear it (`prefs.remove('jwt_token')`) on 401/invalid
  session rather than leaving stale state.
- `_StartupEkrani` (~line 242) validates the saved token against `me.php` on app launch and
  routes to `GirisSayfasi` (login) or straight into the app — any change to what `me.php`
  returns must be reflected here.
- `GirisSayfasi` (~line 447) handles login against `login.php`, including:
  - `_rateLimitBaslat` — a countdown timer disabling repeated login attempts after failures.
  - A demo-mode path (`AnaSayfa(demoModu: true)`) that lets users explore the app with some
    modules gated off — see `demoIzinli` per module tile in `AnaSayfa` (~line 1725 onward,
    `demoIzinli: false/true` per tile).
- Entitlements come back from the backend as a `perms` map. `hasActiveFirePerm(perms)`
  (~line 224) is the single source of truth for whether the fire module is unlocked:
  - `perms['fire'] == 'omur'` → lifetime access, always true.
  - `perms['fire'] == 'yillik'` (or legacy `true`/`'true'`) → active only if
    `perms['fire_activatedAt']` parses and is within 365 days of now.
  - Anything else (`null`, `false`, `'false'`) → no access.
  Always route permission checks through this function; don't re-implement the date-math
  inline elsewhere.
- Account deletion (`delete-account.php`, ~line 15382) reads the token, calls the endpoint,
  then clears `jwt_token` from prefs on success.

## Working conventions

- Any new permission or entitlement flag from the backend should extend the `perms` map
  handling consistently with `hasActiveFirePerm` rather than introducing parallel ad-hoc
  checks in individual screens.
- Network calls use `http` package with explicit `.timeout(...)` — keep that pattern for new
  calls rather than leaving requests unbounded.
- User-facing error/status strings must go through the `.arb` localization files (see the
  `l10n-sync` skill), not hardcoded Turkish/English text.
- The Gemini AI chat integration (`geminiChat()`, `AiSohbetSayfasi`, `ApiAyarlariSayfasi`) is a
  separate, user-supplied-API-key integration against `generativelanguage.googleapis.com`, not
  the mevos.com.tr backend — don't conflate the two auth models. Note the UI sometimes labels
  the Gemini-backed button `_GrokButon`; verify which function is actually wired before
  assuming the name is accurate.
- After changes, run `flutter analyze`. Do not commit or send real JWTs/API keys in test code
  or logs.
