From: akpm@linux-foundation.org
Subject: [folded-merged] thp-prepare-for-dax-huge-pages-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:35:51 -0700
Message-ID: <55ef54b7.vp653ZgiCqtkJq5H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbbIHVfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-prepare-for-dax-huge-pages-fix
has been removed from the -mm tree.  Its filename was
     thp-prepare-for-dax-huge-pages-fix.patch

This patch was dropped because it was folded into thp-prepare-for-dax-huge-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-prepare-for-dax-huge-pages-fix

fix build

mm/huge_memory.c: In function 'zap_huge_pmd':
mm/huge_memory.c:1432: error: implicit declaration of function 'vma_is_dax'

Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-prepare-for-dax-huge-pages-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-prepare-for-dax-huge-pages-fix
+++ a/mm/huge_memory.c
@@ -16,6 +16,7 @@
 #include <linux/swap.h>
 #include <linux/shrinker.h>
 #include <linux/mm_inline.h>
+#include <linux/dax.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

