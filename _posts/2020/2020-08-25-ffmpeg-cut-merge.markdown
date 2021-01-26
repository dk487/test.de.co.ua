---
title: Як нашвидкоруч змонтувати відео
date: 2020-08-25 16:12:00 +03:00
---

Запишу десь тут, щоб не забути.

## Cut video fragment

```sh
ffmpeg -i input.mp4 -vcodec copy -acodec copy -ss 00:01:23 -t 00:04:56 output.mp4
```

## Merge fragments

```sh
echo file 'part1.mp4' > list.txt
echo file 'part2.mp4' >> list.txt
echo file 'part3.mp4' >> list.txt
ffmpeg -f concat -i list.txt -c copy merged.mp4
```