# Nick Craig-Wood's public website

This directory tree is used to build all the different docs for
[Nick Craig-Wood's website](https://www.craig-wood.com/nick/).

The content here is (c) Nick Craig-Wood - if you'd like to use it
elsewhere then please ask first: nick@craig-wood.com

See the `content` directory for the pages in markdown format.

Use [hugo](https://github.com/spf13/hugo) to build the website.

## Changing the layout

If you want to change the layout then the main files to edit are

- `layouts/_default/baseof.html` for the HTML template
- `chrome/navbar.html` for the navbar
- `chrome/menu.html` for the menu

Running `make serve` in a terminal give a live preview of the website
so it is easy to tweak stuff.

## What are all these files

```
├── config.toml                   - hugo config file
├── content                       - docs and backend docs
│   ├── _index.md                 - the front page of the website
├── layouts                       - how the markdown gets converted into HTML
│   ├── 404.html                  - 404 page
│   ├── chrome                    - contains parts of the HTML page included elsewhere
│   │   ├── menu.html             - left hand side menu
│   │   └── navbar.html           - top navigation bar
│   ├── _default
│   │   ├── baseof.html           - the HTML skeleton for all pages
│   │   ├── section.html          - default layout for sections
│   │   └── single.html           - default layout for sections
│   ├── index.html                - the index page of the whole site
│   ├── partials                  - bits of HTML to include into layout .html files
│   ├── rss.xml                   - template for the RSS output
│   ├── section                   - rendering for sections
│   ├── shortcodes                - shortcodes to call from markdown files
│   └── sitemap.xml               - sitemap template
├── public                        - render of the website
├── README.md                     - this file
└── static                        - static content for the website
    ├── css
    │   ├── bootstrap.css
    │   ├── custom.css            - custom css goes here
    │   └── font-awesome.css
    ├── img                       - images used
    ├── js
    │   ├── bootstrap.js
    │   ├── custom.js             - custom javascript goes here
    │   └── jquery.js
    └── webfonts
```
