From: akpm@linux-foundation.org
Subject: + lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch added
 to -mm tree
Date: Mon, 02 Feb 2015 15:18:29 -0800
Message-ID: <54d005c5.zJDiNHmCZ2T2MQKk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbbBBXSa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 18:18:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@arm.linux.org.uk, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig: fix up HAVE_ARCH_BITREVERSE help text
has been added to the -mm tree.  Its filename is
     lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch

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
Subject: lib/Kconfig: fix up HAVE_ARCH_BITREVERSE help text

Cc: Yalin Wang <yalin.wang@sonymobile.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/Kconfig~lib-kconfig-fix-up-have_arch_bitreverse-help-text lib/Kconfig
--- a/lib/Kconfig~lib-kconfig-fix-up-have_arch_bitreverse-help-text
+++ a/lib/Kconfig
@@ -18,9 +18,8 @@ config HAVE_ARCH_BITREVERSE
 	default n
 	depends on BITREVERSE
 	help
-	  This option provides an config for the architecture which have instruction
-	  can do bitreverse operation, we use the hardware instruction if the architecture
-	  have this capability.
+	  This option enables the use of hardware bit-reversal instructions on
+	  architectures which support such operations.
 
 config RATIONAL
 	bool
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
drivers-gpio-gpio-zevioc-fix-build.patch
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

