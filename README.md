# Star Wars Cider Cut

## Raw content

`raw_content/` is ignored by git and should contain local source media only. Do not commit downloaded MP4 files.

Canonical MP4 files live in `raw_content/mp4/` and use lowercase snake case:

- Movies: `episode_<number>_<title>.mp4`
- The Clone Wars: `the_clone_wars_s<season>e<episode>.mp4`

Use zero-padded two-digit season and episode numbers for Clone Wars files.

Examples:

- `raw_content/mp4/episode_3_revenge_of_the_sith.mp4`
- `raw_content/mp4/the_clone_wars_s07e05.mp4`
- `raw_content/mp4/the_clone_wars_s07e08.mp4`

Downloaded files may initially be named from the source URL, such as `001-4194-7-5-star-wars-the-clone-wars.mp4`. Move them into `raw_content/mp4/` and rename them to the canonical format before running scripts that consume raw media.
