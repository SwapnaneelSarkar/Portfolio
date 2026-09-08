#!/usr/bin/env python3
"""Emit one static HTML document per route after `flutter build web`.

Flutter web is a single-page app: Netlify rewrites every path to
index.html, so crawlers saw the homepage <title> and canonical on every
route and folded the sub-pages into "/".  This script clones the built
index.html once per route in tool/routes.json, swaps the head tags
(title, description, canonical, og:*, twitter:*) and prepends a
route-specific <section> to the crawlable mirror's <main>, writing
build/web/_pages/<slug>.html.  web/_redirects maps each path to its file
with a 200 rewrite, ahead of the catch-all.

Run from the repo root:  python3 tool/prerender_routes.py [build/web]
"""
import html
import json
import os
import re
import sys

SITE = "https://swapnaneel-portfolio.netlify.app"
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "build", "web")


def esc(s):
    return html.escape(s, quote=True)


def set_tag(doc, pattern, replacement, count=1):
    new, n = re.subn(pattern, replacement, doc, count=count, flags=re.S)
    if n == 0:
        raise SystemExit(f"prerender: pattern not found: {pattern[:60]}")
    return new


def render(route, base):
    path = route["path"]
    url = SITE + (path if path != "/" else "/")
    title, desc = route["title"], route["description"]
    doc = base
    doc = set_tag(doc, r"<title>.*?</title>", f"<title>{esc(title)}</title>")
    doc = set_tag(doc, r'<meta name="title" content="[^"]*">', f'<meta name="title" content="{esc(title)}">')
    doc = set_tag(doc, r'<meta name="description" content="[^"]*">', f'<meta name="description" content="{esc(desc)}">')
    doc = set_tag(doc, r'<link rel="canonical" href="[^"]*">', f'<link rel="canonical" href="{esc(url)}">')
    doc = set_tag(doc, r'<meta property="og:title" content="[^"]*">', f'<meta property="og:title" content="{esc(title)}">')
    doc = set_tag(doc, r'<meta property="og:description" content="[^"]*">', f'<meta property="og:description" content="{esc(desc)}">')
    doc = set_tag(doc, r'<meta property="og:url" content="[^"]*">', f'<meta property="og:url" content="{esc(url)}">')
    doc = set_tag(doc, r'<meta name="twitter:title" content="[^"]*">', f'<meta name="twitter:title" content="{esc(title)}">')
    doc = set_tag(doc, r'<meta name="twitter:description" content="[^"]*">', f'<meta name="twitter:description" content="{esc(desc)}">')
    if route.get("ogType"):
        doc = set_tag(doc, r'<meta property="og:type" content="[^"]*">', f'<meta property="og:type" content="{esc(route["ogType"])}">')

    # Route-specific crawlable content goes first in <main>; the shared
    # mirror (about, experience, projects…) follows as supporting context.
    section = route.get("html", "")
    if route.get("jsonld"):
        section += '\n<script type="application/ld+json">' + json.dumps(route["jsonld"], ensure_ascii=False) + "</script>"
    if section:
        doc = set_tag(doc, r"<main>", "<main>\n" + section + "\n", count=1)
    # The homepage <h1> must not compete with the route's own <h1>.
    if path != "/" and "<h1" in section:
        doc = doc.replace('<h1 id="name">Swapnaneel Sarkar</h1>', '<p class="brand-h" id="name">Swapnaneel Sarkar</p>', 1)
    return doc


def main():
    with open(os.path.join(ROOT, "tool", "routes.json"), encoding="utf-8") as f:
        routes = json.load(f)
    with open(os.path.join(OUT, "index.html"), encoding="utf-8") as f:
        base = f.read()
    pages = os.path.join(OUT, "_pages")
    os.makedirs(pages, exist_ok=True)
    written = []
    for route in routes:
        if route["path"] == "/":
            continue
        slug = route["path"].strip("/").replace("/", "-")
        target = os.path.join(pages, slug + ".html")
        with open(target, "w", encoding="utf-8") as f:
            f.write(render(route, base))
        written.append((route["path"], f"/_pages/{slug}.html"))
    print(f"prerender: wrote {len(written)} route documents to {pages}")
    for p, t in written:
        print(f"  {p} -> {t}")


if __name__ == "__main__":
    main()
