From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch removed from -mm tree
Date: Thu, 09 Jun 2016 15:42:53 -0700
Message-ID: <5759f0ed.oWE2xeTIQBFs69Bz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbcFIWmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2016 18:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch

This patch was dropped because it was folded into mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix

make calculate_sizes():size a size_t

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix mm/slub.c
--- a/mm/slub.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix
+++ a/mm/slub.c
@@ -3387,7 +3387,7 @@ static void set_min_partial(struct kmem_
 static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	unsigned long flags = s->flags;
-	unsigned long size = s->object_size;
+	size_t size = s->object_size;
 	int order;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

