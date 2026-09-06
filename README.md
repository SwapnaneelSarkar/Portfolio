# Swapnaneel Sarkar — Product Manager Portfolio

Flutter Web portfolio with a calm, content-first layout.

## Sections

| Section | Route | Description |
|---------|--------|-------------|
| Home | `/` | Hero, about, skills, previews |
| Projects | `/projects` | Shipped products (CodeContext, Bird, Grape) |
| Case Studies | `/case-studies` | External product analysis write-ups |
| Experience | `/experience` | Work history |
| Education | `/education` | Academic background |
| Contact | `/contact` | Form and contact details |

Case studies open on their own sites (e.g. [Rapido case study](https://docs.google.com/presentation/d/e/2PACX-1vQ3rq54jbtTAaNcRm0pveJQcdfR22N87B4uTJIIoX2jqYuA3HTlgcmMuvk350BJvC4yJi0WXoiJ2Gn3/pub?start=false&loop=false&delayms=5000)). Projects stay separate from case studies.

## Resume

[Resume on Google Drive](https://drive.google.com/file/d/1KLA3Ttu3Bv_EFI72DeNHV_dtl198Llt0/view?usp=sharing)

## Development

```bash
flutter pub get
flutter run -d chrome
```

Content lives in `lib/data/portfolio_content.dart`.

## SEO

Flutter web paints to a canvas, so search engines cannot read the app itself. Everything crawlable lives in `web/`:

| File | Purpose |
|------|---------|
| `web/index.html` | Title/description/keywords, canonical, Open Graph + Twitter tags, schema.org JSON-LD (`Person`, `WebSite`, `ProfilePage`, project and case-study `ItemList`s), a crawlable HTML mirror of the content (shown until Flutter paints, then kept behind the app), and a per-route `<title>`/meta updater hooked into `history.pushState`. |
| `web/sitemap.xml` | All indexable routes. Bump `<lastmod>` when content changes. |
| `web/robots.txt` | Allows everything except the two game routes; points at the sitemap. |
| `web/_headers` | Netlify cache and security headers. |
| `web/og-image.png` | 1200×630 social preview (LinkedIn, WhatsApp, X, Slack). |
| `web/swapnaneel-sarkar.png` | Headshot referenced by the `Person` schema and the image sitemap. |

When `lib/data/portfolio_content.dart` changes, update the HTML mirror in `web/index.html` to match.

After deploying: verify the site in [Google Search Console](https://search.google.com/search-console) (paste the token into the placeholder comment in `web/index.html`), submit `https://swapnaneel-portfolio.netlify.app/sitemap.xml`, and request indexing for `/`.
