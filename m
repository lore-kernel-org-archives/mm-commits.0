From: akpm@linux-foundation.org
Subject: - blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:11:26 -0700
Message-ID: <200704301911.l3UJBRSQ012497@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946668AbXD3TLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch: need linux/tty.h header for console_init() prototype
has been removed from the -mm tree.  Its filename was
     blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: blackfin arch: need linux/tty.h header for console_init() prototype
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/blackfin/kernel/setup.c~blackfin-arch-need-linux-ttyh-header-for-console_init-prototype arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c~blackfin-arch-need-linux-ttyh-header-for-console_init-prototype
+++ a/arch/blackfin/kernel/setup.c
@@ -34,6 +34,7 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/console.h>
+#include <linux/tty.h>
 
 #include <linux/ext2_fs.h>
 #include <linux/cramfs_fs.h>
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
