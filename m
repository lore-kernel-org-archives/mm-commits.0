From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:43:07 -0800
Message-ID: <20121211234308.3A94E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48161 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2LKXnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:43:09 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so6391ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:43:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes

ERROR: trailing whitespace
#43: FILE: arch/alpha/include/asm/mman.h:73:
+ */  $

ERROR: trailing whitespace
#62: FILE: arch/mips/include/uapi/asm/mman.h:97:
+ */  $

ERROR: trailing whitespace
#81: FILE: arch/parisc/include/uapi/asm/mman.h:80:
+ */  $

ERROR: trailing whitespace
#100: FILE: arch/xtensa/include/uapi/asm/mman.h:103:
+ */  $

total: 4 errors, 0 warnings, 94 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h       |    2 +-
 arch/mips/include/uapi/asm/mman.h   |    2 +-
 arch/parisc/include/uapi/asm/mman.h |    2 +-
 arch/xtensa/include/uapi/asm/mman.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/alpha/include/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes
+++ a/arch/alpha/include/asm/mman.h
@@ -70,7 +70,7 @@
  *
  * Assume these are all power of twos.
  * When 0 use the default page size.
- */  
+ */
 #define MAP_HUGE_SHIFT	26
 #define MAP_HUGE_MASK	0x3f
 
diff -puN arch/mips/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -94,7 +94,7 @@
  *
  * Assume these are all power of twos.
  * When 0 use the default page size.
- */  
+ */
 #define MAP_HUGE_SHIFT	26
 #define MAP_HUGE_MASK	0x3f
 
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -77,7 +77,7 @@
  *
  * Assume these are all power of twos.
  * When 0 use the default page size.
- */  
+ */
 #define MAP_HUGE_SHIFT	26
 #define MAP_HUGE_MASK	0x3f
 
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -100,7 +100,7 @@
  *
  * Assume these are all power of twos.
  * When 0 use the default page size.
- */  
+ */
 #define MAP_HUGE_SHIFT	26
 #define MAP_HUGE_MASK	0x3f
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
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

