# Motion Rules

## Easing
Preferred: `cubic-bezier(0.22, 1, 0.36, 1)`
Entrance: `cubic-bezier(0.0, 0.0, 0.2, 1)`
Exit: `cubic-bezier(0.4, 0.0, 1, 1)`

## Duration
- Micro (hover, focus): 100–150ms
- UI (modals, dropdowns): 200–300ms
- Page transitions: 400–600ms
- Cinematic reveals: 800–1200ms

## Rules
- Motion must feel weighted and physical
- Use layered transitions (opacity + translate together)
- Prefer `transform` and `opacity` — never animate layout properties
- Use staggered children with 60–80ms delay increments
- Add subtle parallax only on hero sections

## Avoid
- Spring bouncing on navigation elements
- Excessive blur transitions
- Distracting floating or pulsing effects
- Scale animations beyond 1.05 on hover
