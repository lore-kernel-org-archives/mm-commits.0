From: akpm@linux-foundation.org
Subject: +
 mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch added
 to -mm tree
Date: Mon, 13 Oct 2014 12:36:41 -0700
Message-ID: <543c29c9.NF40kFDHvnHO5OMN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaJMTgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 15:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch

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
Subject: mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes

WARNING: else is not generally useful after a break or return
#36: FILE: mm/cma.c:63:
+		return 0;
+	else

total: 0 errors, 1 warnings, 11 lines checked

./patches/mm-cma-fix-cma-bitmap-aligned-mask-computing.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes mm/cma.c
--- a/mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes
+++ a/mm/cma.c
@@ -60,8 +60,7 @@ static unsigned long cma_bitmap_aligned_
 {
 	if (align_order <= cma->order_per_bit)
 		return 0;
-	else
-		return (1UL << (align_order - cma->order_per_bit)) - 1;
+	return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

