# Active Rehab System Summary

This is the current starting point for the project.

## Current State

- Live domain: `https://activerehab.vercel.app`
- Sitemap URLs (EN + AR): `568`
- Published injury protocols: `100`
- Internal injury library: `138`
- Articles: `14`
- Diet plans: `10`
- Calculators: `11`
- Exercise categories: `20`
- Training systems: `7`

## Main Entry Files

- [README](./README.md)
- [Implementation Guide](./IMPLEMENTATION_GUIDE.md)
- [Quick Reference](./QUICK_REFERENCE.md)

## What The App Includes

- Bilingual routing with `/en/*` and `/ar/*`
- Injury recovery protocols
- Nutrition plans
- Clinical calculators
- Exercise libraries and training systems
- AI assistant, dashboard, auth, and admin pages

## Run Locally

```bash
npm install
npm run dev
```

## Build

```bash
npm run build
```

## Notes

- `README.md` is the canonical overview.
- `docs/migration/` contains legacy migration notes and archived setup docs.
- Sitemap generation uses the generated/public injury set, not every internal record.
