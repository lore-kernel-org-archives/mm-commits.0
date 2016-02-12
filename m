From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 11 Feb 2016 16:09:20 -0800
Message-ID: <56bd22b0.KOCIJZfCrlSyzyGE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbcBLAJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Feb 2016 19:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range-checkpatch-fixes.patch

This patch was dropped because it was folded into mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range-checkpatch-fixes

WARNING: 'threshhold' may be misspelled - perhaps 'threshold'?
#22: FILE: mm/pgtable-generic.c:93:
+ * entire TLB if flush span is greater than a threshhold, which will

total: 0 errors, 1 warnings, 11 lines checked

./patches/mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/pgtable-generic.c~mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range-checkpatch-fixes mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range-checkpatch-fixes
+++ a/mm/pgtable-generic.c
@@ -90,7 +90,7 @@ pte_t ptep_clear_flush(struct vm_area_st
  * ARCHes with special requirements for evicting THP backing TLB entries can
  * implement this. Otherwise also, it can help optimize normal TLB flush in
  * THP regime. stock flush_tlb_range() typically has optimization to nuke the
- * entire TLB if flush span is greater than a threshhold, which will
+ * entire TLB if flush span is greater than a threshold, which will
  * likely be true for a single huge page. Thus a single thp flush will
  * invalidate the entire TLB which is not desirable.
  * e.g. see arch/arc: flush_pmd_tlb_range
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-config_nr_zones_extended-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

