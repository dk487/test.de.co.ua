---
title: <span lang="en">My localhost</span>
date: 2020-12-10 06:29:28 +02:00
---

```php
$vhosts = array_map('basename', glob('/var/www/vhosts/[a-z]*'));

foreach($vhosts as $vhost) {
  mt_srand(crc32($vhost));
  $hue = mt_rand(0, 359);
  $css = "style=\"background: hsl($hue, 80%, 80%)\"";
  echo "<li><a href=\"http://$vhost\" $css>$vhost</a></li>\n";
}
```

[![localhost.png](/uploads/localhost.png)](/uploads/localhost.png)

 - <https://gist.github.com/kastaneda/4e028a961ee97f542f942afa638ae94b>
 - <https://jsfiddle.net/kastaneda/c176j4ut/show>

Cross-post: <https://twitter.com/kastaneda/status/1336860446155010048>
