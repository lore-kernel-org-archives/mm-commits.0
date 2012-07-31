From: akpm@linux-foundation.org
Subject: [folded] mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:29:21 -0700
Message-ID: <20120731232921.5F3D1A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:46696 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811Ab2GaX3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 19:29:23 -0400
Received: by lagr15 with SMTP id r15so298402lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:29:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes

ERROR: trailing whitespace
#62: FILE: mm/fadvise.c:106:
+^I^I * Ignore return value because fadvise() shall return $

ERROR: trailing whitespace
#64: FILE: mm/fadvise.c:108:
+^I^I */^I^I$

total: 2 errors, 0 warnings, 30 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes
+++ a/mm/fadvise.c
@@ -103,9 +103,9 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 			nrpages = ~0UL;
 
 		/*
-		 * Ignore return value because fadvise() shall return 
+		 * Ignore return value because fadvise() shall return
 		 * success even if filesystem can't retrieve a hint,
-		 */		
+		 */
 		force_page_cache_readahead(mapping, file, start_index,
 					   nrpages);
 		break;
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
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

