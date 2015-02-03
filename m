From: akpm@linux-foundation.org
Subject: [obsolete] drivers-gpio-gpio-zevioc-fix-build.patch removed from
 -mm tree
Date: Tue, 03 Feb 2015 13:25:56 -0800
Message-ID: <54d13ce4.o951+5kFJSTAkwL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161164AbbBCVZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 16:25:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabian@ritter-vogt.de, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpio/gpio-zevio.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-gpio-gpio-zevioc-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/gpio/gpio-zevio.c: fix build

Unbreak i386 allmodconfig.

This is a hack - please fix properly ;)

Cc: Fabian Vogt <fabian@ritter-vogt.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpio-zevio.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/gpio/gpio-zevio.c~drivers-gpio-gpio-zevioc-fix-build drivers/gpio/gpio-zevio.c
--- a/drivers/gpio/gpio-zevio.c~drivers-gpio-gpio-zevioc-fix-build
+++ a/drivers/gpio/gpio-zevio.c
@@ -18,6 +18,10 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 
+#ifndef IOMEM
+#define IOMEM(x)    ((void __force __iomem *)(x))
+#endif
+
 /*
  * Memory layout:
  * This chip has four gpio sections, each controls 8 GPIOs.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

