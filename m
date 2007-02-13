From: akpm@linux-foundation.org
Subject: + spi-atmel_spi-driver-fix.patch added to -mm tree
Date: Tue, 13 Feb 2007 00:34:22 -0800
Message-ID: <200702130834.l1D8YMii026175@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXBMIef (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 03:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com


The patch titled
     spi-atmel_spi-driver-fix
has been added to the -mm tree.  Its filename is
     spi-atmel_spi-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi-atmel_spi-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/spi/atmel_spi.c~spi-atmel_spi-driver-fix drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-atmel_spi-driver-fix
+++ a/drivers/spi/atmel_spi.c
@@ -159,7 +159,6 @@ static void atmel_spi_next_xfer(struct s
 		xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
 		xfer->rx_buf, xfer->rx_dma, spi_readl(as, IMR));
 
-	wmb();
 	spi_writel(as, TCR, len);
 	spi_writel(as, RCR, len);
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
git-agpgart.patch
git-arm.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-infiniband.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
git-watchdog.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
spi-atmel_spi-driver-fix.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch
