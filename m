From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:42:57 -0800
Message-ID: <20121211234257.DDA89100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64681 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2LKXm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:42:59 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so10184qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:42:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch

This patch was dropped because it was folded into mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix

missed one

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix
+++ a/fs/hugetlbfs/inode.c
@@ -1053,7 +1053,7 @@ static int __init init_hugetlbfs_fs(void
 		char buf[50];
 		unsigned ps_kb = 1U << (h->order + PAGE_SHIFT - 10);
 
-		snprintf(buf, sizeof buf, "pagesize=%uK", ps_kb);
+		snprintf(buf, sizeof(buf), "pagesize=%uK", ps_kb);
 		hugetlbfs_vfsmount[i] = kern_mount_data(&hugetlbfs_fs_type,
 							buf);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
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

