From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch added to -mm
 tree
Date: Mon, 13 Apr 2020 16:07:17 -0700
Message-ID: <20200413230717.mVBevIlYL%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389929AbgDMXHR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 19:07:17 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: fix a typo in comment "convienence"->"convenience"
has been added to the -mm tree.  Its filename is
     mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch

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
Subject: mm/sparse: fix a typo in comment "convienence"->"convenience"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411002955.14545-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-fix-a-typo-in-comment-convienence-convenience
+++ a/mm/sparse.c
@@ -288,7 +288,7 @@ void __init memory_present(int nid, unsi
 
 /*
  * Mark all memblocks as present using memory_present(). This is a
- * convienence function that is useful for a number of arches
+ * convenience function that is useful for a number of arches
  * to mark all of the systems memory as present during initialization.
  */
 void __init memblocks_present(void)
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
