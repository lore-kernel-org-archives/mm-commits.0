From: akpm@linux-foundation.org
Subject: +
 mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch added to -mm tree
Date: Mon, 25 Jan 2016 14:44:58 -0800
Message-ID: <56a6a56a.c/ng2m6U8k51cvYb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbcAYWo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 17:44:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@fedoraproject.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch

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
Subject: mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes

WARNING: 'occuring' may be misspelled - perhaps 'occurring'?
#57: FILE: mm/Kconfig.debug:74:
+	   zeros. This makes it harder to detect when errors are occuring

total: 0 errors, 1 warnings, 47 lines checked

./patches/mm-page_poisoningc-allow-for-zero-poisoning.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig.debug~mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes
+++ a/mm/Kconfig.debug
@@ -71,7 +71,7 @@ config PAGE_POISONING_ZERO
 	depends on PAGE_POISONING
 	---help---
 	   Instead of using the existing poison value, fill the pages with
-	   zeros. This makes it harder to detect when errors are occuring
+	   zeros. This makes it harder to detect when errors are occurring
 	   due to sanitization but the zeroing at free means that it is
 	   no longer necessary to write zeros when GFP_ZERO is used on
 	   allocation.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

