# MoviesDemo

A small SwiftUI demo app that browses and searches movies using [The Movie Database (TMDB)](https://www.themoviedb.org) API.

## Getting started

### 1. Get a TMDB API key

The app talks directly to the TMDB API, so you need your own key:

1. Create a free account at [themoviedb.org](https://www.themoviedb.org/signup).
2. Go to **Settings → API** ([direct link](https://www.themoviedb.org/settings/api)) and request an API key (the "Developer" option is free).
3. Copy your **API Key (v3 auth)** — a 32-character string.

### 2. Provide the key without committing it

The key is read at runtime from the `TMDB_API_KEY` environment variable, so it
never lives in the repository. Set it in your local Xcode scheme:

1. Open `MoviesDemo.xcworkspace` in Xcode.
2. **Product → Scheme → Edit Scheme…** (or `⌘<`).
3. Select **Run** in the sidebar, then the **Arguments** tab.
4. Under **Environment Variables**, add:

   | Name           | Value              |
   |----------------|--------------------|
   | `TMDB_API_KEY` | _your 32-char key_ |

5. Close the dialog and run the app (`⌘R`).

> The Run scheme lives in `xcuserdata/`, which is gitignored — your key stays
> on your machine and is never committed.

If `TMDB_API_KEY` is unset, requests are sent with an empty key and TMDB
returns an authentication error.
