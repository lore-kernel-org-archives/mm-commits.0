From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Nov 2017 16:56:13 -0800
Message-ID: <5a0ce22d.ZZXvVJwmKwD7ih0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932597AbdKPA4O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:56:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes

WARNING: line over 80 characters
#84: FILE: mm/memory.c:2910:
+					GFP_HIGHUSER_MOVABLE, vma, vmf->address);

total: 0 errors, 1 warnings, 62 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes
+++ a/mm/memory.c
@@ -2907,7 +2907,7 @@ int do_swap_page(struct vm_fault *vmf)
 					GFP_HIGHUSER_MOVABLE, vmf, &swap_ra);
 			else
 				page = swapin_readahead(entry,
-					GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+				       GFP_HIGHUSER_MOVABLE, vma, vmf->address);
 			swapcache = page;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

