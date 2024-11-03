
dv mostly uses standard unix tooling, but also some custom commands I
wrote: packmime, unpackmime, and llpipe. You can install them from
npmjs, as shown in [the repo readme](../README.md).

Alternatively, if you want to explore creating your own versions,
they're within the realm of what Claude 3.5 (Nov 2024) can implement
in a few tries. The prompts I used to do that are in this directory.

I dropped these prompts directly into the Web UI for Claude, not using
dv tools, to see if I could bootstrap the system. unpackmime needed a
few iteratings for debugging the parser, but the other two worked on
the first try.

The versions currently in npmjs are likely revised from those
bootstrap versions by hand and/or using dv.