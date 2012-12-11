From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-vm_unmapped_area-on-sh-architecture-fix2.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:48:05 -0800
Message-ID: <20121211234805.D1A7C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53339 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2LKXsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:48:06 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so6952ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:48:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-vm_unmapped_area-on-sh-architecture-fix2
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-sh-architecture-fix2.patch

This patch was dropped because it was folded into mm-use-vm_unmapped_area-on-sh-architecture.patch

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm-use-vm_unmapped_area-on-sh-architecture-fix2



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/sh/mm/mmap.c~mm-use-vm_unmapped_area-on-sh-architecture-fix2 arch/sh/mm/mmap.c
--- a/arch/sh/mm/mmap.c~mm-use-vm_unmapped_area-on-sh-architecture-fix2
+++ a/arch/sh/mm/mmap.c
@@ -35,7 +35,6 @@ unsigned long arch_get_unmapped_area(str
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long start_addr;
 	int do_colour_align;
 	struct vm_unmapped_area_info info;
 
_

Patches currently in -mm which might be from walken@google.com are

mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
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

