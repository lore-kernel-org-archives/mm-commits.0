From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:48:22 -0800
Message-ID: <20121211234823.A7FFA200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55915 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2LKXs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:48:26 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so1925bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:48:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-vm_unmapped_area-on-sparc32-architecture-fix
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch

This patch was dropped because it was folded into mm-use-vm_unmapped_area-on-sparc32-architecture.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-vm_unmapped_area-on-sparc32-architecture-fix

arch/sparc/kernel/sys_sparc_32.c: In function 'arch_get_unmapped_area':
arch/sparc/kernel/sys_sparc_32.c:41:26: error: unused variable 'vmm' [-Werror=unused-variable]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_32.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/sparc/kernel/sys_sparc_32.c~mm-use-vm_unmapped_area-on-sparc32-architecture-fix arch/sparc/kernel/sys_sparc_32.c
--- a/arch/sparc/kernel/sys_sparc_32.c~mm-use-vm_unmapped_area-on-sparc32-architecture-fix
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -38,7 +38,6 @@ asmlinkage unsigned long sys_getpagesize
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	struct vm_area_struct * vmm;
 	struct vm_unmapped_area_info info;
 
 	if (flags & MAP_FIXED) {
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
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
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

