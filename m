From: akpm@linux-foundation.org
Subject: [folded-merged] mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:45:48 -0800
Message-ID: <20121211234549.36B2520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:49054 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2LKXpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:45:51 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so2883lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:45:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vm_unmapped_area-lookup-function-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-vm_unmapped_area-lookup-function.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vm_unmapped_area-lookup-function-checkpatch-fixes

WARNING: labels should not be indented
#127: FILE: mm/mmap.c:1549:
+	check_current:

WARNING: labels should not be indented
#229: FILE: mm/mmap.c:1651:
+	check_current:

total: 0 errors, 2 warnings, 386 lines checked

./patches/mm-vm_unmapped_area-lookup-function.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-vm_unmapped_area-lookup-function-checkpatch-fixes mm/mmap.c
--- a/mm/mmap.c~mm-vm_unmapped_area-lookup-function-checkpatch-fixes
+++ a/mm/mmap.c
@@ -1602,7 +1602,7 @@ unsigned long unmapped_area(struct vm_un
 		}
 
 		gap_start = vma->vm_prev ? vma->vm_prev->vm_end : 0;
-	check_current:
+check_current:
 		/* Check if current node has a suitable gap */
 		if (gap_start > high_limit)
 			return -ENOMEM;
@@ -1704,7 +1704,7 @@ unsigned long unmapped_area_topdown(stru
 			}
 		}
 
-	check_current:
+check_current:
 		/* Check if current node has a suitable gap */
 		gap_end = vma->vm_start;
 		if (gap_end < low_limit)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

