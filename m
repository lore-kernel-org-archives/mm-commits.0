From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 16 Oct 2014 11:16:24 -0700
Message-ID: <54400b78.IofV5al4V4PX+yMe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPSQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 14:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/reset/Kconfig |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN drivers/power/reset/Kconfig~linux-next-git-rejects drivers/power/reset/Kconfig
--- a/drivers/power/reset/Kconfig~linux-next-git-rejects
+++ a/drivers/power/reset/Kconfig
@@ -59,11 +59,7 @@ config POWER_RESET_GPIO
 
 config POWER_RESET_GPIO_RESTART
 	bool "GPIO restart driver"
-<<<<<<< HEAD
-	depends on OF_GPIO
-=======
 	depends on OF_GPIO && POWER_RESET
->>>>>>> linux-next/akpm-base
 	help
 	  This driver supports restarting your board via a GPIO line.
 	  If your board needs a GPIO high/low to restart, say Y and
@@ -83,11 +79,7 @@ config POWER_RESET_MSM
 
 config POWER_RESET_LTC2952
 	bool "LTC2952 PowerPath power-off driver"
-<<<<<<< HEAD
-	depends on OF_GPIO
-=======
 	depends on OF_GPIO && POWER_RESET
->>>>>>> linux-next/akpm-base
 	help
 	  This driver supports an external powerdown trigger and board power
 	  down via the LTC2952. Bindings are made in the device tree.
@@ -117,11 +109,7 @@ config POWER_RESET_SUN6I
 
 config POWER_RESET_ST
 	bool "ST restart power-off driver"
-<<<<<<< HEAD
-	depends on ARCH_STI
-=======
 	depends on POWER_RESET && ARCH_STI
->>>>>>> linux-next/akpm-base
 	help
 	  Power off and reset support for STMicroelectronics boards.
 
@@ -157,11 +145,7 @@ config POWER_RESET_KEYSTONE
 
 config POWER_RESET_SYSCON
 	bool "Generic SYSCON regmap reset driver"
-<<<<<<< HEAD
-	depends on OF
-=======
 	depends on POWER_RESET && OF
->>>>>>> linux-next/akpm-base
 	select MFD_SYSCON
 	help
 	  Reboot support for generic SYSCON mapped register reset.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

