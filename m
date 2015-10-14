From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 14 Oct 2015 12:43:30 -0700
Message-ID: <561eb062.Z7YWRzcTVBEtvi1n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbbJNTnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 15:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/crypto/camellia_aesni_avx_glue.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/x86/crypto/camellia_aesni_avx_glue.c~linux-next-git-rejects arch/x86/crypto/camellia_aesni_avx_glue.c
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c~linux-next-git-rejects
+++ a/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -559,12 +559,8 @@ static int __init camellia_aesni_init(vo
 		return -ENODEV;
 	}
 
-<<<<<<< HEAD
-	if (!cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, &feature_name)) {
-=======
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				&feature_name)) {
->>>>>>> linux-next/akpm-base
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
lib-kconfig-zlib_deflate-must-select-bitreverse.patch
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
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

