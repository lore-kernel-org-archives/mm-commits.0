From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 15:38:38 -0700
Message-ID: <20200413223838.ZH5c5g9ZU%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgDMWif (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 18:38:35 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix a typo in comment "pessemistic"->"pessimistic"
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/compaction: fix a typo in comment "pessemistic"->"pessimistic"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411070307.16021-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic
+++ a/mm/compaction.c
@@ -1401,7 +1401,7 @@ fast_isolate_freepages(struct compact_co
 		if (scan_start) {
 			/*
 			 * Use the highest PFN found above min. If one was
-			 * not found, be pessemistic for direct compaction
+			 * not found, be pessimistic for direct compaction
 			 * and use the min mark.
 			 */
 			if (highest) {
_

Patches currently in -mm which might be from ethp@qq.com are

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
mm-vmsan-fix-some-typos-in-comment.patch
mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch
mm-memblock-fix-a-typo-in-comment-implict-implicit.patch
mm-list_lru-fix-a-typo-in-comment-numbesr-numbers.patch
