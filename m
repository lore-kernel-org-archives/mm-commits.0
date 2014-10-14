From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:17:05 -0700
Message-ID: <543d68a1.v7qydQE838Y8kTWs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaJNSRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN arch/arm64/mm/dma-mapping.c~linux-next-rejects arch/arm64/mm/dma-mapping.c
diff -puN drivers/clk/Kconfig~linux-next-rejects drivers/clk/Kconfig
--- a/drivers/clk/Kconfig~linux-next-rejects
+++ a/drivers/clk/Kconfig
@@ -32,12 +32,23 @@ config COMMON_CLK_WM831X
 
 source "drivers/clk/versatile/Kconfig"
 
+config COMMON_CLK_MAX_GEN
+	bool
+
 config COMMON_CLK_MAX77686
 	tristate "Clock driver for Maxim 77686 MFD"
 	depends on MFD_MAX77686
+	select COMMON_CLK_MAX_GEN
 	---help---
 	  This driver supports Maxim 77686 crystal oscillator clock. 
 
+config COMMON_CLK_MAX77802
+	tristate "Clock driver for Maxim 77802 PMIC"
+	depends on MFD_MAX77686
+	select COMMON_CLK_MAX_GEN
+	---help---
+	  This driver supports Maxim 77802 crystal oscillator clock.
+
 config COMMON_CLK_RK808
 	tristate "Clock driver for RK808"
 	depends on MFD_RK808
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

