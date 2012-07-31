From: akpm@linux-foundation.org
Subject: [folded] mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:31:06 -0700
Message-ID: <20120731233106.A0425A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43759 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2GaXbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:31:07 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4818782obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:31:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-have-order-0-compaction-start-off-where-it-left-v3-typo
has been removed from the -mm tree.  Its filename was
     mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch

This patch was dropped because it was folded into mm-have-order-0-compaction-start-off-where-it-left.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-have-order-0-compaction-start-off-where-it-left-v3-typo

s/laste/last/, use 80 cols

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3-typo mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3-typo
+++ a/mm/compaction.c
@@ -571,11 +571,10 @@ static isolate_migrate_t isolate_migrate
 }
 
 /*
- * Returns the start pfn of the laste page block in a zone.
- * This is the starting point for full compaction of a zone.
- * Compaction searches for free pages from the end of each zone,
- * while isolate_freepages_block scans forward inside each page
- * block.
+ * Returns the start pfn of the last page block in a zone.  This is the starting
+ * point for full compaction of a zone.  Compaction searches for free pages from
+ * the end of each zone, while isolate_freepages_block scans forward inside each
+ * page block.
  */
 static unsigned long start_free_pfn(struct zone *zone)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

