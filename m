From: akpm@linux-foundation.org
Subject: + blackfin-arch-power-management-replace-firmware-disk-mode.patch added to -mm tree
Date: Mon, 26 Mar 2007 14:10:39 -0700
Message-ID: <200703262110.l2QLAdGS030658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52065 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbXCZVKm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:10:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin arch: power management replace firmware disk mode
has been added to the -mm tree.  Its filename is
     blackfin-arch-power-management-replace-firmware-disk-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin arch: power management replace firmware disk mode
From: "Wu, Bryan" <bryan.wu@analog.com>

This patches replace firmware disk mode according to include/linux/pm.h

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-common/pm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/blackfin/mach-common/pm.c~blackfin-arch-power-management-replace-firmware-disk-mode arch/blackfin/mach-common/pm.c
--- a/arch/blackfin/mach-common/pm.c~blackfin-arch-power-management-replace-firmware-disk-mode
+++ a/arch/blackfin/mach-common/pm.c
@@ -166,7 +166,7 @@ static int bfin_pm_finish(suspend_state_
 }
 
 struct pm_ops bfin_pm_ops = {
-	.pm_disk_mode = PM_DISK_FIRMWARE,
+	.pm_disk_mode = PM_DISK_PLATFORM,
 	.prepare = bfin_pm_prepare,
 	.enter = bfin_pm_enter,
 	.finish = bfin_pm_finish,
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
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
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
