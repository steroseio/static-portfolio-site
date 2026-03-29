# Steve Rose Portfolio Website

This repository powers my personal portfolio and blog, built with Astro.

It is also shared so others can fork it and adapt it into their own portfolio site.

## What You Get

- Astro-based static site with blog, tags, categories, RSS, sitemap, and OG image generation
- Accessibility-focused UI with light/dark theme support
- Content collection for markdown blog posts
- AI-facing content endpoints (`/api/content.json`, `/api/markdown/{slug}`)
- Terraform infrastructure for production hosting (S3 + CloudFront + Cloudflare DNS + ACM)

## Run Locally

Requirements:

- Node.js 20+
- npm

Install and run:

```bash
npm install
npm run dev
```

Build and preview:

```bash
npm run build
npm run preview
```

Local dev runs on `http://localhost:4321`.

## Environment Variables

- `PUBLIC_SITE_URL` (or `SITE_URL`): canonical site URL used in metadata.
- `PUBLIC_COUNTER_API_URL`: full counter endpoint URL used by footer counter (for example `https://abc123.execute-api.us-east-1.amazonaws.com/counter`).

If `PUBLIC_COUNTER_API_URL` is not set, the footer counter is hidden.

## Make It Your Own

If you want to adapt this repo as your own portfolio, these are the main files to change first:

1. [src/config/site.ts](src/config/site.ts): site name, canonical URL, author metadata, nav links, social links.
2. [src/pages/index.astro](src/pages/index.astro): homepage content and CTA.
3. [src/pages/about.astro](src/pages/about.astro): biography and profile content.
4. [src/pages/now.astro](src/pages/now.astro): current focus/projects.
5. [src/content/blog/](src/content/blog): your blog posts.
6. [public/](public): favicons, resume PDF, robots/ai metadata.
7. [src/styles/main.css](src/styles/main.css): design tokens and visual theme.

Also set your production URL via `PUBLIC_SITE_URL` or `SITE_URL` when building/deploying, and set `PUBLIC_COUNTER_API_URL` if you want the footer counter enabled.

## Project Layout

```text
.
├── infrastructure/         # Terraform for S3 + CloudFront + Cloudflare
├── public/                 # Static files
├── src/
│   ├── components/
│   ├── config/
│   ├── content/blog/
│   ├── layouts/
│   ├── pages/
│   └── styles/
├── package.json
└── package-lock.json
```

## API and Feeds

- `GET /api/content.json`: structured site + blog metadata
- `GET /api/markdown.json`: markdown API usage/discovery response
- `GET /api/markdown/{slug}`: markdown body for a specific post
- `GET /rss.xml`: RSS feed
- `GET /site.webmanifest`: PWA manifest

## Hosting with Terraform

Infrastructure code lives in [infrastructure/](infrastructure).

The stack provisions:

- Private S3 bucket for site assets
- CloudFront distribution with TLS
- Cloudflare DNS records (`apex` and `www`)
- ACM certificate validation

Follow [infrastructure/README.md](infrastructure/README.md) for backend bootstrap (state bucket + lock table) and first apply.

Typical deployment flow after infrastructure exists:

```bash
npm run build
aws s3 sync ./dist s3://<site-bucket-name> --delete
aws cloudfront create-invalidation --distribution-id <distribution-id> --paths "/*"
```

## CI/CD Roadmap (Recommended)

This repo can be promoted from manual deploys to one-click releases with a pipeline (for example GitHub Actions):

1. Run `npm ci`
2. Run `npm run build`
3. Run tests/checks (for example `npx astro check`)
4. Sync `dist/` to S3
5. Invalidate CloudFront

Longer-term improvements:

- Separate `terraform plan` and `terraform apply` workflows
- Protected production environment approvals
- Preview environments for PRs

## Notes for Forks

- Keep `package.json` and `package-lock.json` committed for reproducible installs.
- Pick one package manager and one lock file for your fork.
- Update domain, social handles, and resume path before publishing.
