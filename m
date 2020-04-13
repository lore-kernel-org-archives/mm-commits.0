From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-fix-a-typo-in-comment-attampt-attempt.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 16:07:21 -0700
Message-ID: <20200413230721.at4eoi1hy%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389929AbgDMXHW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 19:07:22 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: fix a typo in comment "attampt"->"attempt"
has been added to the -mm tree.  Its filename is
     mm-memory-fix-a-typo-in-comment-attampt-attempt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-fix-a-typo-in-comment-attampt-attempt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-fix-a-typo-in-comment-attampt-attempt.patch

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
Subject: mm/memory: fix a typo in comment "attampt"->"attempt"

There is a comment in typo, fix it.

Link: http://lkml.kernel.org/r/20200411004043.14686-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-a-typo-in-comment-attampt-attempt
+++ a/mm/memory.c
@@ -2469,7 +2469,7 @@ static inline bool cow_user_page(struct
 		}
 
 		/*
-		 * The same page can be mapped back since last copy attampt.
+		 * The same page can be mapped back since last copy attempt.
 		 * Try to copy again under PTL.
 		 */
 		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
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
