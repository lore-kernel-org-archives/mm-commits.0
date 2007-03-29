From: akpm@linux-foundation.org
Subject: + blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch added to -mm tree
Date: Thu, 29 Mar 2007 15:16:56 -0700
Message-ID: <200703292216.l2TMGuKv013571@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41073 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422684AbXC2WQ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 18:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin arch fix stamp537 ISP1716 IRQ setting bug
has been added to the -mm tree.  Its filename is
     blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin arch fix stamp537 ISP1716 IRQ setting bug
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/blackfin/mach-bf537/boards/stamp.c~blackfin-arch-fix-stamp537-isp1716-irq-setting-bug arch/blackfin/mach-bf537/boards/stamp.c
--- a/arch/blackfin/mach-bf537/boards/stamp.c~blackfin-arch-fix-stamp537-isp1716-irq-setting-bug
+++ a/arch/blackfin/mach-bf537/boards/stamp.c
@@ -68,7 +68,7 @@ static struct resource bfin_isp1761_reso
 	[1] = {
 		.start  = ISP1761_IRQ,
 		.end    = ISP1761_IRQ,
-		.flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+		.flags  = IORESOURCE_IRQ,
 	},
 };
 
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
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
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
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
