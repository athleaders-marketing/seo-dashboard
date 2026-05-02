# Athleaders SEO Dashboard

Static dashboard at `dashboard.athleaders.ae/seo-dashboard/`.

## Local preview

```bash
./scripts/serve.sh
```
Opens a server on port 8000. Refresh the browser to see changes.

## Deploy

```bash
./scripts/deploy.sh "short commit message"
```
Confirms before pushing. Push triggers GitHub Action which FTP-syncs to Hostinger.

## Working with Claude Code

Open this folder in Claude Code. The `CLAUDE.md` file is loaded automatically as session context. Tell Claude what to change in plain English.

## Data sources

Google Sheet: `1ehZ25abYm6Fj2LtJFHn1X-WIG1jI0XkOyRe6yuo4bag`. Must be shared as Anyone-with-link Viewer.

Apps Script project (separate from this repo) populates the sheet via the Ahrefs and GSC APIs twice weekly.
