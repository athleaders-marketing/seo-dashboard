# Athleaders SEO Dashboard

Persistent context for Claude Code sessions. Read fully before making changes.

## What this project is

A single-file HTML dashboard at `dashboard.athleaders.ae/seo-dashboard/` that visualises SEO performance for two markets: `athleaders.ae` (UAE/Dubai) and `athleaders.co` (Singapore). The owner is Swarnendu (marketing at Athleaders).

The dashboard reads live data from a Google Sheet via the public `gviz/tq` endpoint. Two Google Apps Script jobs populate that sheet twice weekly. The dashboard itself is static HTML hosted on Hostinger; nothing is server-rendered.

## Repository

GitHub: `https://github.com/athleaders-marketing/seo-dashboard`
Live URL: `https://dashboard.athleaders.ae/seo-dashboard/`
Branch: `main` (only branch; deploys on push)
Push to main triggers `.github/workflows/deploy.yml` which FTP-syncs to Hostinger.

## Architecture

One file: `index.html`. Self-contained. CDN-loaded Chart.js. No build step, no npm, no React. Vanilla JS.

Page-load sequence:
1. Fetch all needed sheet tabs in parallel via `gviz/tq` (currently 21 tabs across both markets plus one shared).
2. If all fetches succeed, populate `state.data` and render the active page.
3. If any subset fails, fall back to embedded `SAMPLE` data and show the yellow demo-mode banner.
4. Switching markets or pages re-renders from cached state. No re-fetch within a session.

Do not introduce a build step. Do not split into multiple files. Do not introduce a backend. Do not import Google Fonts or external CSS frameworks. The radical simplicity is the strength.

## Current state of pages

| Page | Status | Data source |
|------|--------|-------------|
| Domain Overview | Functional | `*_Ahrefs_Domain`, `*_Ahrefs_Backlinks_Stats`, `*_Ahrefs_Top_RefDomains`, `*_Ahrefs_Top_Pages`, `*_Ahrefs_DR_History`, `*_Ahrefs_RD_History` |
| Rankings | Functional | `*_GSC_Weekly`, `*_GSC_Targets` (volume lookup) |
| Top Pages | Functional | `*_Ahrefs_Top_Pages` |
| Discovery Queries | Functional | `*_GSC_Discovery` |
| Backlinks | Functional | `*_Ahrefs_Top_Backlinks`, `*_Ahrefs_Top_RefDomains`, `*_Ahrefs_Anchors`, `*_Ahrefs_RD_History` |
| Web Vitals | Placeholder | Pending PageSpeed Insights pipeline |
| Activity Log | Functional with empty-state | `Activity_Log` (shared tab; manual entry) |
| Methodology | Static | None |

## Data sources

**Google Sheet ID:** `1ehZ25abYm6Fj2LtJFHn1X-WIG1jI0XkOyRe6yuo4bag`

This sheet must be shared as "Anyone with the link can view" or `gviz/tq` returns 404. If the demo banner appears live, that share setting is the first thing to check.

**Apps Scripts (separate project, not in this repo):**
- GSC pipeline: pulls weekly Search Console data for tracked keywords plus untracked discovery queries. Runs Mondays.
- Ahrefs pipeline: pulls Ahrefs domain/backlink/page metrics. Runs Mondays and Fridays at 00:05 GST.

If asked to debug missing data, point to the Apps Script project's execution log first. Do not assume triggers are set; they need manual setup in the Apps Script UI.

**Sheet tab schemas the dashboard consumes:**

For each market prefix `AE_` and `CO_`:
- `*_Ahrefs_Domain` — append-per-run. Cols: `run_date`, `domain_rating`, `ahrefs_rank`, `org_keywords`, `org_keywords_1_3`, `org_traffic`, `org_cost`. Latest row = current; second-to-last = prev for delta.
- `*_Ahrefs_Backlinks_Stats` — append-per-run. Cols: `run_date`, `live_backlinks`, `all_time_backlinks`, `live_refdomains`, `all_time_refdomains`. Same pattern.
- `*_Ahrefs_Top_RefDomains` — replace. Cols: `run_date`, `domain_rating`, `domain`, `links_to_target`, `dofollow_links`, `first_seen`, `last_seen`.
- `*_Ahrefs_Top_Pages` — replace. Cols: `run_date`, `url`, `sum_traffic`, `value`, `top_keyword`, `top_keyword_best_position`, `keywords`, `referring_domains`.
- `*_Ahrefs_Top_Backlinks` — replace. Cols include: `domain_rating`, `url_from`, `url_to`, `anchor`, `is_dofollow`, `first_seen`.
- `*_Ahrefs_Anchors` — replace. Cols: `run_date`, `anchor`, `refdomains`, `dofollow_links`, `top_domain_rating`, `first_seen`.
- `*_Ahrefs_DR_History` — replace. Cols: `date`, `domain_rating`. 24 monthly points.
- `*_Ahrefs_RD_History` — replace. Cols: `date`, `refdomains`, `dofollow_refdomains`, `new_refdomains`, `lost_refdomains`. 24 monthly points.
- `*_GSC_Weekly` — append weekly. Cols: `Week Ending`, `Keyword`, `Best Position`, `Avg Position`, `Clicks`, `Impressions`, `CTR`, `Days Active`. ~70 weeks of history per keyword.
- `*_GSC_Discovery` — append weekly. Cols include: `Week Ending`, `Query`, `Clicks`, `Impressions`, `Avg Position`, `CTR`. Untracked queries.
- `*_GSC_Targets` — defined list. Cols: `keyword` (col A), `volume` (col B), and possibly `target_url`, `enabled`. Used as a volume lookup by the Rankings page.

Shared (single tab, both markets):
- `Activity_Log` — manual entries. Cols: `Date`, `Market` (AE/CO/BOTH), `Type`, `Description`, `URL`. Optional; page shows empty state if tab missing.

## Design system: Mockup A "The Steward"

Approved aesthetic. Private bank, not SaaS. Cloud-white background, charcoal text, gold eyebrows, hairline rules, monospace numbers, sparse layouts. Pink is rare and reserved for hero accents and the active sidebar item border. Do not pinkify.

Density was deliberately tightened in the latest pass: hero h1 32px, section padding 28px / 40px, KPI value 26px, table cells 10-11px / 14px. The result is roughly 30-40% more information per screen than the original mockup. Keep it tight.

**Colour tokens (CSS variables in `index.html`):**

```
--pink: #FF2F8A         primary brand, hero accents only
--pink-light: #FF6BAE   secondary
--dark: #1A1816         deepest text
--charcoal: #2D2926     body text and headings
--cloud: #FAF7F2        page background
--white: #FFFFFF        card background
--gold: #C9A96E         eyebrow labels, section markers
--cream: #EDE8E0        methodology footer
--grey: #6B7280         muted text
--hairline: rgba(45,41,38,0.08)   default border
```

**Voice and style rules:**
- Sentence case for headings. No exclamation marks.
- No em dashes ever. Use commas, semicolons, or rephrase.
- Confident not arrogant. Premium not exclusive.
- Methodology footer on every data page.

**Typography:**
- Body: system font stack (`-apple-system, BlinkMacSystemFont, ...`). Do NOT import Google Fonts.
- Numbers in tables and KPI deltas: monospace stack (`'SF Mono', Monaco, ...`).

## Common tasks

**Preview locally:**
```bash
./scripts/serve.sh
# open http://localhost:8000
```
The local preview hits the live Google Sheet, so what you see locally is what will deploy.

**Deploy a change:**
```bash
./scripts/deploy.sh "short commit message"
```
Confirms before pushing. Uses `git add -A`, commits, pushes to main. Push triggers GitHub Action which FTP-syncs to Hostinger.

**Add a new page:**
1. Add nav item in sidebar with `data-page="newname"` and `onclick="switchPage('newname')"`.
2. Add `<section class="page" id="page-newname">` in `<main>` with an inner `<div id="newname-content">`.
3. Determine which sheet tabs are needed; add fetches to `loadData()`.
4. Write a `renderNewname()` function that reads `state.data[code]` and outputs HTML.
5. Register in `pageRenderers` and `pageLabels` dictionaries.
6. Add a methodology footer.
7. Add sample data to `SAMPLE.AE` and `SAMPLE.CO` for offline mode.

**Debug missing data on the live site:**
1. Open browser console. Look for fetch errors or `gviz status not_found`.
2. Check sheet sharing (Anyone with link, Viewer).
3. Open the Apps Script project; check the most recent execution log.
4. If a specific tab is missing data, run `runAhrefsRefresh` or `runWeeklyUpdate` manually.

**Read sheet contents directly (debugging or feature design):**

If the Google Drive MCP is connected, read the sheet via the connector. Otherwise, hit the gviz endpoint directly:
```
https://docs.google.com/spreadsheets/d/1ehZ25abYm6Fj2LtJFHn1X-WIG1jI0XkOyRe6yuo4bag/gviz/tq?tqx=out:json&sheet=TAB_NAME
```

**Explore Ahrefs data outside the existing pipeline:**

Use the Ahrefs MCP tools. Useful for designing new features, finding competitive intel, or proving out hypotheses before extending the Apps Script.

## Anti-patterns

Push back if asked to:
- Introduce a build step (webpack, Vite, npm) for this project.
- Split `index.html` into multiple files.
- Import Google Fonts or external CSS frameworks.
- Change the colour palette without explicit sign-off.
- Use em dashes or exclamation marks in user-facing text.
- "Pinkify" the design; pink is rare, deliberate, and reserved.
- Assume Apps Script triggers are set; they require manual setup.
- Loosen the density that was just tightened.

## Identity and history

Swarnendu manages marketing at Athleaders. Background context: an SEO agency was previously providing weekly reports with inflated ranking data, which is what triggered the rebuild on a defensible foundation. Trust in numbers is the meta-feature of this dashboard. Do not ship a metric you cannot defend methodologically. When in doubt, document the source in the methodology footer.

Athleaders is a premium personal training business. Brand archetype: Ruler 70%, Caregiver 30%. The visual language is meant to feel like a private banking client report, not a marketing dashboard. Singapore positioning: quiet luxury. Dubai positioning: visible premium. Both polished.
