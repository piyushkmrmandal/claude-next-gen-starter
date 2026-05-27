# COMPONENT RULES

## Preferred Sources
1. 21st.dev — inspiration and premium patterns
2. Magic UI — animated components
3. Aceternity UI — immersive effects
4. shadcn/ui — base primitives

## Always
- Customize all imported components
- Maintain spacing consistency with 8px grid
- Preserve visual hierarchy through size and weight
- Optimize for responsiveness (mobile-first)
- Use reusable abstractions with typed props

## Component Structure
- One component per file
- Co-locate types at top of file
- Export named, not default
- Props interface before component
- No inline styles — Tailwind only

## Avoid
- Monolithic components over 200 lines
- Prop drilling beyond 2 levels
- Untyped event handlers
- Hardcoded colors outside design tokens
