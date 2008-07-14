From: akpm@linux-foundation.org
Subject: - mtd-atmel_nand-can-be-modular.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:44 -0700
Message-ID: <200807141935.m6EJZi3F023948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757295AbYGNTgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, haavard.skinnemoen@atmel.com, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     MTD: atmel_nand can be modular
has been removed from the -mm tree.  Its filename was
     mtd-atmel_nand-can-be-modular.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD: atmel_nand can be modular
From: David Brownell <dbrownell@users.sourceforge.net>

There's no reason to prevent the Atmel NAND driver from
building as a module.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/Kconfig~mtd-atmel_nand-can-be-modular drivers/mtd/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~mtd-atmel_nand-can-be-modular
+++ a/drivers/mtd/nand/Kconfig
@@ -272,7 +272,7 @@ config MTD_NAND_CS553X
 	  If you say "m", the module will be called "cs553x_nand.ko".
 
 config MTD_NAND_ATMEL
-	bool "Support for NAND Flash / SmartMedia on AT91 and AVR32"
+	tristate "Support for NAND Flash / SmartMedia on AT91 and AVR32"
 	depends on ARCH_AT91 || AVR32
 	help
 	  Enables support for NAND Flash / Smart Media Card interface
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

gpio-pcf857x-add-lock-and-handle-more-chips.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
pm-boot-time-suspend-selftest-update.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
spi-spi_mpc83xx-clockrate-fixes.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
spi-au1550_spi-proper-platform-device.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
rtc-remove-bkl-for-ioctl.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch

