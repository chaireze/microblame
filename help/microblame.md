# microblame


This plugin exposes a command so that the statusbar can show you the git blame for the line your cursor is on.

If you change your `settings.json` configuration file to include `$(microblame.blame)` in either the `statusformatr`
or `statusformatl` attributes, the blame will appear in either the right or left status lines, respectively.

The blame has the format `<author name> <relative time of commit> <commit message>`

This is a work in progress and not extensively tested. Just did this for fun.

