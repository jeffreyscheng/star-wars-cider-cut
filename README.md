# Star Wars Cider Cut

## Raw content

`raw_content/mp4/` is ignored by git and should contain local source media only. Do not commit downloaded MP4 files.

Canonical MP4 files live in `raw_content/mp4/` and use lowercase snake case:

- Movies: `episode_<number>_<title>.mp4`
- The Clone Wars: `the_clone_wars_s<season>e<episode>.mp4`
- Tales of the Jedi: `tales_of_the_jedi_s<season>e<episode>.mp4`

Subtitle files live in `raw_content/srt/` and use the same file stem as the corresponding MP4, with a `.srt` extension. Use zero-padded two-digit season and episode numbers for TV files.

Examples:

- `raw_content/mp4/episode_3_revenge_of_the_sith.mp4`
- `raw_content/mp4/the_clone_wars_s07e05.mp4`
- `raw_content/mp4/the_clone_wars_s07e08.mp4`
- `raw_content/mp4/tales_of_the_jedi_s01e01.mp4`
- `raw_content/srt/episode_3_revenge_of_the_sith.srt`
- `raw_content/srt/the_clone_wars_s07e05.srt`
- `raw_content/srt/tales_of_the_jedi_s01e01.srt`

Downloaded files may initially be named from the source URL, such as `001-4194-7-5-star-wars-the-clone-wars.mp4`. Move them into `raw_content/mp4/` and rename them to the canonical format before running scripts that consume raw media.

## Subtitle sources

The current `.srt` files were downloaded from SUBDL and normalized into the canonical file names above. SUBDL pages embed subtitle metadata in the `__NEXT_DATA__` JSON payload; each selected subtitle has a `link` value like `2927632-2919509.zip`. The direct download URL is:

```text
https://dl.subdl.com/subtitle/<link>
```

Sources used:

- Movies: individual SUBDL movie pages for Episodes I-VI.
- The Clone Wars: `sd1300164/star-wars-the-clone-wars`, English season pages.
- Tales of the Jedi: `sd1651474/star-wars-tales-of-the-jedi`, English season page.

For TV season packs, unzip the downloaded archive and rename each `SxxEyy` subtitle to the canonical stem, for example `Star.Wars.Tales.of.the.Jedi.S01E01...srt` becomes `raw_content/srt/tales_of_the_jedi_s01e01.srt`.
