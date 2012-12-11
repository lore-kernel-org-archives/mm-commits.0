From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:50:11 -0800
Message-ID: <20121211235011.B6CB8100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36751 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2LKXuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:50:12 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so7568ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:50:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix.patch

This patch was dropped because it was folded into mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/hugetlbpage.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/sparc/mm/hugetlbpage.c~mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -60,7 +60,6 @@ hugetlb_get_unmapped_area_topdown(struct
 				  const unsigned long pgoff,
 				  const unsigned long flags)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
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
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch

