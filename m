From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Thu, 12 Feb 2015 11:34:26 -0800
Message-ID: <54dd0042.4RAQsPmH4bHunruD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbBLTe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:34:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/module-common.lds |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN scripts/module-common.lds~linux-next-rejects scripts/module-common.lds
--- a/scripts/module-common.lds~linux-next-rejects
+++ a/scripts/module-common.lds
@@ -6,17 +6,17 @@
 SECTIONS {
 	/DISCARD/ : { *(.discard) }
 
-	__ksymtab		: { *(SORT(___ksymtab+*)) }
-	__ksymtab_gpl		: { *(SORT(___ksymtab_gpl+*)) }
-	__ksymtab_unused	: { *(SORT(___ksymtab_unused+*)) }
-	__ksymtab_unused_gpl	: { *(SORT(___ksymtab_unused_gpl+*)) }
-	__ksymtab_gpl_future	: { *(SORT(___ksymtab_gpl_future+*)) }
-	__kcrctab		: { *(SORT(___kcrctab+*)) }
-	__kcrctab_gpl		: { *(SORT(___kcrctab_gpl+*)) }
-	__kcrctab_unused	: { *(SORT(___kcrctab_unused+*)) }
-	__kcrctab_unused_gpl	: { *(SORT(___kcrctab_unused_gpl+*)) }
-	__kcrctab_gpl_future	: { *(SORT(___kcrctab_gpl_future+*)) }
+	__ksymtab		0 : { *(SORT(___ksymtab+*)) }
+	__ksymtab_gpl		0 : { *(SORT(___ksymtab_gpl+*)) }
+	__ksymtab_unused	0 : { *(SORT(___ksymtab_unused+*)) }
+	__ksymtab_unused_gpl	0 : { *(SORT(___ksymtab_unused_gpl+*)) }
+	__ksymtab_gpl_future	0 : { *(SORT(___ksymtab_gpl_future+*)) }
+	__kcrctab		0 : { *(SORT(___kcrctab+*)) }
+	__kcrctab_gpl		0 : { *(SORT(___kcrctab_gpl+*)) }
+	__kcrctab_unused	0 : { *(SORT(___kcrctab_unused+*)) }
+	__kcrctab_unused_gpl	0 : { *(SORT(___kcrctab_unused_gpl+*)) }
+	__kcrctab_gpl_future	0 : { *(SORT(___kcrctab_gpl_future+*)) }
 
 	. = ALIGN(8);
-	.init_array		: { *(SORT(.init_array.*)) *(.init_array) }
+	.init_array		0 : { *(SORT(.init_array.*)) *(.init_array) }
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-rework-reset-and-destroy-path-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
module_device_table-fix-some-callsites.patch
kasan-enable-instrumentation-of-global-variables-fix.patch
kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
samples-seccomp-improve-label-helper-fix.patch
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

