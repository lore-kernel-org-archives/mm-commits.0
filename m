From: akpm@linux-foundation.org
Subject: [folded-merged] mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:45:33 -0800
Message-ID: <20121211234534.295C220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62493 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2LKXpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:45:36 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so2877lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:45:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#55: FILE: include/linux/mm_types.h:250:
+	struct mm_struct * vm_mm;	/* The address space we belong to. */

total: 1 errors, 0 warnings, 30 lines checked

./patches/mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm_types.h~mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes
+++ a/include/linux/mm_types.h
@@ -247,7 +247,7 @@ struct vm_area_struct {
 
 	/* Second cache line starts here. */
 
-	struct mm_struct * vm_mm;	/* The address space we belong to. */
+	struct mm_struct *vm_mm;	/* The address space we belong to. */
 	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
 	unsigned long vm_flags;		/* Flags, see mm.h. */
 
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
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
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

