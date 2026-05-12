# Mood Board Notes — Style Descriptor Strings

These strings are appended to every Veo 3.1 prompt to keep the visual look consistent across the film. Every shot — present-day and memory alike — is rendered as photorealistic cinematic live-action. The only difference between present and memory is a subtle warm haze in the memory shots that signals recollection without stylizing the image.

## Present-day scenes (Bay Area home, transit, Sunrise at FlatIrons interior)

Used for shots 01, 02, 03, 04, 14, 15, 16.

```
photorealistic cinematic realism, live-action film quality, warm naturalistic color grade, shallow depth of field, authentic human expressions and real human skin, natural lighting, subtle film grain, Chloé Zhao aesthetic
```

## Memory scenes (Australia preschool, China market, Colorado slope)

Used for shots 05–13. Identical to the present-day descriptor plus a subtle warmth phrase that reads as "memory" to the viewer without making the image stylized:

```
photorealistic cinematic realism, live-action film quality, warm naturalistic color grade, shallow depth of field, authentic human expressions and real human skin, natural lighting, subtle film grain, Chloé Zhao aesthetic, slightly softer memory grade with faint warm haze suggesting recollection
```

## Universal negative prompt

Appended to every shot's negative prompt to block common failure modes and prevent any drift away from photorealism:

```
animated, cartoon, anime, painted, watercolor, oil painting, ink-wash, illustration style, CGI look, plastic skin, uncanny valley faces, distorted fingers, six-fingered hands, modern logos, text artifacts, cluttered background, harsh contrast
```

## Why a single photorealistic style for the whole film

Keeping one consistent cinematic look across both present-day and memory scenes makes the memories feel like real recollections rather than fantasy sequences. The characters, their faces, and the moments they share carry the emotional weight — not a stylized medium. The subtle warm haze on memory shots is enough to tell the viewer "this is a memory" while keeping the people and places grounded and believable.
