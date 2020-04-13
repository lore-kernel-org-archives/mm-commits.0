From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-frontswap-fix-some-typos-in-frontswapc.patch added
 to -mm tree
Date: Mon, 13 Apr 2020 15:51:50 -0700
Message-ID: <20200413225150.MaZOS7795%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389710AbgDMWuo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 18:50:44 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap: fix some typos in frontswap.c
has been added to the -mm tree.  Its filename is
     mm-frontswap-fix-some-typos-in-frontswapc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-frontswap-fix-some-typos-in-frontswapc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-frontswap-fix-some-typos-in-frontswapc.patch

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
Subject: mm/frontswap: fix some typos in frontswap.c

There are some typos in comment, fix them.

s/Fortunatly/Fortunately
s/taked/taken
s/necessory/necessary
s/shink/shrink

Link: http://lkml.kernel.org/r/20200411064009.15727-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/frontswap.c~mm-frontswap-fix-some-typos-in-frontswapc
+++ a/mm/frontswap.c
@@ -87,7 +87,7 @@ static inline void inc_frontswap_invalid
  *
  * This would not guards us against the user deciding to call swapoff right as
  * we are calling the backend to initialize (so swapon is in action).
- * Fortunatly for us, the swapon_mutex has been taked by the callee so we are
+ * Fortunately for us, the swapon_mutex has been taken by the callee so we are
  * OK. The other scenario where calls to frontswap_store (called via
  * swap_writepage) is racing with frontswap_invalidate_area (called via
  * swapoff) is again guarded by the swap subsystem.
@@ -413,8 +413,8 @@ static int __frontswap_unuse_pages(unsig
 }
 
 /*
- * Used to check if it's necessory and feasible to unuse pages.
- * Return 1 when nothing to do, 0 when need to shink pages,
+ * Used to check if it's necessary and feasible to unuse pages.
+ * Return 1 when nothing to do, 0 when need to shrink pages,
  * error code when there is an error.
  */
 static int __frontswap_shrink(unsigned long target_pages,
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
mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary.patch
mm-frontswap-fix-some-typos-in-frontswapc.patch
mm-memcg-fix-some-typos-in-memcontrolc.patch
mm-fix-a-typo-in-comment-strucure-structure.patch
