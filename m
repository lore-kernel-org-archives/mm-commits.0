From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 16:07:15 -0700
Message-ID: <20200413230715.Uwlj10_cW%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389929AbgDMXHP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 19:07:15 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix a typo in comment "disambiguiation"->"disambiguation"
has been added to the -mm tree.  Its filename is
     mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch

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
Subject: mm/slub: fix a typo in comment "disambiguiation"->"disambiguation"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411002247.14468-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation
+++ a/mm/slub.c
@@ -1984,7 +1984,7 @@ static void *get_partial(struct kmem_cac
 
 #ifdef CONFIG_PREEMPTION
 /*
- * Calculate the next globally unique transaction for disambiguiation
+ * Calculate the next globally unique transaction for disambiguation
  * during cmpxchg. The transactions start with the cpu number and are then
  * incremented by CONFIG_NR_CPUS.
  */
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
