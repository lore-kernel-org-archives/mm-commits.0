From: akpm@linux-foundation.org
Subject: [folded-merged] sparc-add-pmd_-for-thp-fix.patch removed from -mm tree
Date: Mon, 02 Nov 2015 15:12:31 -0800
Message-ID: <5637eddf.ZYMkG8UmTeVaWkow%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbbKBXMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 18:12:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc-add-pmd_-for-thp-fix
has been removed from the -mm tree.  Its filename was
     sparc-add-pmd_-for-thp-fix.patch

This patch was dropped because it was folded into sparc-add-pmd_-for-thp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sparc-add-pmd_-for-thp-fix

mm-fix-huge-zero-page-accounting-in-smaps-report.patch already added
pmd-dirty()

Cc: Minchan Kim <minchan@kernel.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc-add-pmd_-for-thp-fix arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc-add-pmd_-for-thp-fix
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -667,13 +667,6 @@ static inline unsigned long pmd_young(pm
 	return pte_young(pte);
 }
 
-static inline int pmd_dirty(pmd_t pmd)
-{
-	pte_t pte = __pte(pmd_val(pmd));
-
-	return pte_dirty(pte);
-}
-
 static inline unsigned long pmd_write(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
sparc-add-pmd_-for-thp.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

