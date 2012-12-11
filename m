From: akpm@linux-foundation.org
Subject: [folded-merged] mm-augment-vma-rbtree-with-rb_subtree_gap-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:44:39 -0800
Message-ID: <20121211234440.5083420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:55395 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2LKXom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:44:42 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so1822eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:44:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-augment-vma-rbtree-with-rb_subtree_gap-fix
has been removed from the -mm tree.  Its filename was
     mm-augment-vma-rbtree-with-rb_subtree_gap-fix.patch

This patch was dropped because it was folded into mm-augment-vma-rbtree-with-rb_subtree_gap.patch

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm-augment-vma-rbtree-with-rb_subtree_gap-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap-fix mm/mmap.c
--- a/mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap-fix
+++ a/mm/mmap.c
@@ -1914,7 +1914,7 @@ int expand_upwards(struct vm_area_struct
 				if (vma->vm_next)
 					vma_gap_update(vma->vm_next);
 				else
-					mm->highest_vm_end = address;
+					vma->vm_mm->highest_vm_end = address;
 				perf_event_mmap(vma);
 			}
 		}
_

Patches currently in -mm which might be from walken@google.com are

mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix2.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch

