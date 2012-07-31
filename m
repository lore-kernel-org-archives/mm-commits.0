From: akpm@linux-foundation.org
Subject: [folded] mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:31:01 -0700
Message-ID: <20120731233101.3E77AA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43759 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2GaXbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:31:02 -0400
Received: by obbwc20 with SMTP id wc20so4818782obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:31:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-have-order-0-compaction-start-off-where-it-left.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes

ERROR: trailing whitespace
#94: FILE: mm/compaction.c:583:
+^I * end of a zone; it completes when the migrate and free scanner meet. $

total: 1 errors, 0 warnings, 103 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-have-order-0-compaction-start-off-where-it-left.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes
+++ a/mm/compaction.c
@@ -580,7 +580,7 @@ static int compact_finished(struct zone 
 
 	/*
 	 * A full (order == -1) compaction run starts at the beginning and
-	 * end of a zone; it completes when the migrate and free scanner meet. 
+	 * end of a zone; it completes when the migrate and free scanner meet.
 	 * A partial (order > 0) compaction can start with the free scanner
 	 * at a random point in the zone, and may have to restart.
 	 */
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
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

