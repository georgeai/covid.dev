# **g1y**: 1y with other features 😅

## What is this?

**g1y** is a short URL manager built with [Eleventy](https://www.11ty.dev/) (a.k.a. **1**1t**y**), the great JavaScript/Node based Static Site Generator.

This is not a URL "shortener", as it doesn't process anything. Short and long versions of URLs are managed manually, so that short URLs can be "beautiful".

Also included are `/notes` (like blog posts), `/messages` with background images, and `/holidays` like `/messages`but for holidays and special occasions

## How does it work?

**g1y** generates redirection rules from your set of data, each URL being stored in a Markdown file:
- the `fileSlug` of the Markdown file (the filename without the extension [in 11ty language](https://www.11ty.dev/docs/data/#page-variable-contents)) is the short URL. For example, the Markdown file `pluto.md` you'll find in this template repository is used to create the [https://\<your-short-domain\>/**pluto**](https://<your-short-domain>/pluto) short URL.
- the long URL is stored in the file's [Front Matter](https://www.11ty.dev/docs/data-frontmatter/), for example here the `pluto.md` file only contains these 3 lines:
    ```markdown
    ---
    url: https://en.wikipedia.org/wiki/Pluto
    ---
    ```

So for this example, when you go to [https://\<your-short-domain\>/**pluto**](https://<your-short-domain>/pluto), it redirects you to <https://en.wikipedia.org/wiki/Pluto>.

Redirection rules are generated in 4 formats to ease usage on different environments:
- Apache HTTP server with [Alias module](https://httpd.apache.org/docs/current/en/mod/mod_alias.html) in a `.htaccess` file
- Apache HTTP server with [Rewrite module](https://httpd.apache.org/docs/current/en/mod/mod_rewrite.html) (less efficient) in the same `.htaccess` file
- [Netlify](https://netlify.com/) hosting with [redirects](https://docs.netlify.com/routing/redirects/) in a `_redirects` file
- HTML pages with both [HTML redirect](https://css-tricks.com/redirect-web-page/#article-header-id-1) (`<meta>` tag) and [JavaScript Redirect](https://css-tricks.com/redirect-web-page/#article-header-id-2). This is only meant as a last resort, only there if previous formats don't work. Your HTTP server needs to be able to respond to [https://\<your-short-domain\>/**pluto**](https://<your-short-domain>/pluto) with this actual resource: [https://\<your-short-domain\>/**pluto/index.html**](https://<your-short-domain>/pluto/index.html)
- [Vercel](https://vercel.com/) also works -- not sure which one of the formats it's using.

You don't have to deal with any settings to chose which one to use, all 4 formats are generated at once.

## README.md as blog

Using the github.com or gitea self-hosted git repository, the README.md can also serve as the blog.

A script (`bin/ar-multi-readme.sh`) is included to add any notes using the relative url shortcut eg, `your-post` which points to a note eg, `/notes/2021-01-20-your-post.md` and  prepends the note(s) to README.md, which makes the github or gitea repo url a (poor man's) blog, with links to each of the included posts in the repo.

  ```bash
  # prepend your-post, another-post, yet-another-post notes 
  # to README.md and blog.md files which reside in repo root
  # (although could be /another_dir/blog.md)
  bin/ar-multi-readme.sh your-post,another-post,yet-another-post README.md,blog.md 
  ```

Eventually will need a way to trim / cull the README.md

## Credits

Modified from https://github.com/nhoizey/1y

Kudos to 1y

## License

[MIT](http://opensource.org/licenses/MIT)

Copyright (c) 2021-present
