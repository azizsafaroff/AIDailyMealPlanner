# AI Daily Meal Planner

A no-backend, offline-first meal planning app: onboard once with your goals
and preferences, get one AI-generated daily meal plan, and tweak it —
swap out foods you dislike or regenerate the whole day — within a shared
daily credit budget.

## Setup

1. Install dependencies:
   ```
   flutter pub get
   ```
2. Run the app:
   ```
   flutter run
   ```

The app calls the OpenAI API directly from the client (no backend/proxy),
the same pattern as the AudioScript app. You need an `OPENAI_API_KEY`:

1. Copy `.env.example` to `.env`.
2. Set `OPENAI_API_KEY` to your key. `.env` is git-ignored and never
   committed.

Without a `.env`/key, API calls fail gracefully (error shown in-app,
nothing crashes) — or set `useMockApiClient = true` in
[`lib/api/api_config.dart`](lib/api/api_config.dart) to run fully offline
against `MockMealPlanApiClient`, which fabricates plausible plans locally.

## Feature list

- **Splash + Disclaimer** (first launch only) — intro screen, then a
  general-suggestion / not-medical-advice notice, before onboarding.
- **Onboarding** (one-time, 8 questions) — age/height/weight/gender, goal,
  exercise level, wake/sleep time, country, diet type, meals-per-day
  preference, budget. Generates today's first plan for free.
- **Home** — today's plan as a chronological timeline (time, meal, food
  cards), auto-scrolled and highlighted to the current meal. Top bar (pinned)
  has a drawer toggle and the date/goal/calories; a "Regenerate X/5" button
  for the whole day sits in a sticky bottom bar.
- **Remove/swap a food** — tap a food's thumbs-down to remove it; if
  credits remain, an AI replacement is fetched automatically, otherwise
  it's removed with no replacement.
- **Drawer** — live daily targets (calories/protein/carbs/fat/water) plus
  navigation to History and Edit profile.
- **History / History detail** — past daily plans, read-only.
- **Edit profile** — same 8 fields, editable any time; saving regenerates
  today's plan.

## Business rules — regenerate credits

A shared pool of 5 credits per calendar day, stored per-date so it resets
automatically at local midnight. Regenerating the whole day, swapping a
single food (when credits remain), and saving profile changes all draw
from this same pool. The very first plan of the day (onboarding, or day
rollover) is free. Once the pool hits 0, profile Save gets exactly one
bonus try before it locks until the next day; the Regenerate button and
food swap-with-replacement simply stop working until then.

Every AI request includes `dislikedFoods` and `allergicFoods` from the
profile as exclusions.

## `lib/` structure

- `lib/models/` — `UserProfile` (+ enums), `DailyPlan`/`MealEntry`/
  `FoodItem`/`DailyTargets`/`ProfileSummary`, `RegenUsage`. All with JSON
  (de)serialization matching the AI response shape and storage keys.
- `lib/logic/`
  - `storage_service.dart` — `shared_preferences`-backed persistence for
    `user_profile`, `daily_plan_<date>`, `regen_usage_<date>`,
    `history_index`, and the disclaimer-seen flag.
  - `app_service.dart` — the single `ChangeNotifier` powering the app:
    onboarding/disclaimer state, day rollover, and all regenerate-credit
    business rules.
  - `date_keys.dart` — `YYYY-MM-DD` date-key helpers.
- `lib/api/` — `MealPlanApiClient` interface (`generatePlan`,
  `generateFullPlan`, `swapFood`), `OpenAiMealPlanApiClient` (default —
  calls the OpenAI Chat Completions API directly with `OPENAI_API_KEY`
  from `.env`, JSON-mode prompts, `http`-based), `MockMealPlanApiClient`
  (offline fallback, local placeholder data), `api_config.dart`
  (mock/live toggle).
- `lib/theme/` — `AppTheme`/`AppColors`, matching the design mockup
  (Hanken Grotesk + Space Mono via `google_fonts`, indigo gradient accent).
- `lib/ui/screens/` — `RootScreen` (phase router), `IntroScreen` (local
  splash → disclaimer flow), `SplashScreen`, `DisclaimerScreen`,
  `OnboardingScreen`, `HomeScreen`, `HistoryScreen`, `HistoryDetailScreen`,
  `ProfileScreen`.
- `lib/ui/widgets/` — `MealSection`/`FoodCard` (shared by Home and History
  Detail), `AppDrawer`, `ProfileFormFields` (shared by Onboarding and
  Profile), `GradientButton`/`RegenerateButton`, `ChipOption`, dialogs.
- `lib/ui/food_glyph.dart` — keyword-based emoji fallback, only used for
  food items saved before the AI started generating its own `glyph`.

Icons throughout use [Lucide](https://lucide.dev) (`lucide_icons` package)
to match the design mockup's icon set.
