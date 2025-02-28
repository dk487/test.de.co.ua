---
title: Mozilla перейшла на бік зла
date: 2025-02-28 15:24:30 +02:00
mtime: 2025-02-28 15:31:23 +02:00
---

Щось погане відбуваєтсья.

Ось [цитата][1] з <span lang="en">Firefox Terms of Use</span>:

<div lang="en" markdown=1>
> When you upload or input information through Firefox, **you hereby grant us a nonexclusive, royalty-free, worldwide license to use that information** to help you navigate, experience, and interact with online content as you indicate with your use of Firefox.
</div>

А ось [цікавий коміт][2] в репозиторії. Видалили одне речення:

<div lang="en" markdown=1>
> Firefox is independent and a part of the not-for-profit Mozilla, which fights for your online rights, keeps corporate powers in check and makes the internet accessible to everyone, everywhere. We believe the internet is for people, not profit. <del>Unlike other companies, we don’t sell access to your data.</del> You’re in control over who sees your search and browsing history. All that and exceptional performance too.
</div>

[1]: https://www.mozilla.org/en-US/about/legal/terms/firefox/#you-give-mozilla-certain-rights-and-perm

[2]: https://github.com/mozilla/bedrock/commit/d459addab846d8144b61939b7f4310eb80c5470e
