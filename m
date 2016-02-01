From: akpm@linux-foundation.org
Subject: + mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
 added to -mm tree
Date: Mon, 01 Feb 2016 15:55:48 -0800
Message-ID: <56aff084.61DGAPdNCZOwsDb5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbcBAXzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 18:55:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-put-the-freelist-at-the-end-of-slab-page-fix
has been added to the -mm tree.  Its filename is
     mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch

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
Subject: mm-slab-put-the-freelist-at-the-end-of-slab-page-fix

fix kerneldoc

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/slab.c~mm-slab-put-the-freelist-at-the-end-of-slab-page-fix mm/slab.c
--- a/mm/slab.c~mm-slab-put-the-freelist-at-the-end-of-slab-page-fix
+++ a/mm/slab.c
@@ -1868,7 +1868,6 @@ static void slabs_destroy(struct kmem_ca
  * calculate_slab_order - calculate size (page order) of slabs
  * @cachep: pointer to the cache that is being created
  * @size: size of objects to be created in this cache.
- * @align: required alignment for the objects.
  * @flags: slab allocation flags
  *
  * Also calculates the number of objects per slab.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
arm-arch-arm-include-asm-pageh-needs-personalityh-fix.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

