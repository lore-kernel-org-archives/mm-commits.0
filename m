From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 16:07:19 -0700
Message-ID: <20200413230719.PsBYFjhkL%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389929AbgDMXHT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 19:07:19 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: fix a typo in comment "effictive"->"effective"
has been added to the -mm tree.  Its filename is
     mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch

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
Subject: mm/page-writeback: fix a typo in comment "effictive"->"effective"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411003513.14613-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-fix-a-typo-in-comment-effictive-effective
+++ a/mm/page-writeback.c
@@ -257,7 +257,7 @@ static void wb_min_max_ratio(struct bdi_
  * requiring writeback.
  *
  * This number of dirtyable pages is the base value of which the
- * user-configurable dirty ratio is the effictive number of pages that
+ * user-configurable dirty ratio is the effective number of pages that
  * are allowed to be actually dirtied.  Per individual zone, or
  * globally by using the sum of dirtyable pages over all zones.
  *
_

Patches currently in -mm which might be from ethp@qq.com are

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already-v2.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch
mm-vmsan-fix-some-typos-in-comment.patch
mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch
mm-memblock-fix-a-typo-in-comment-implict-implicit.patch
mm-list_lru-fix-a-typo-in-comment-numbesr-numbers.patch
mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary.patch
mm-frontswap-fix-some-typos-in-frontswapc.patch
mm-memcg-fix-some-typos-in-memcontrolc.patch
mm-fix-a-typo-in-comment-strucure-structure.patch
mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch
mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch
mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch
mm-memory-fix-a-typo-in-comment-attampt-attempt.patch
