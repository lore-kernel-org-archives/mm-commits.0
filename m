From: akpm@linux-foundation.org
Subject: + mtd-atmel_nand-can-be-modular.patch added to -mm tree
Date: Tue, 01 Jul 2008 14:28:20 -0700
Message-ID: <200807012128.m61LSKNf015536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYGAV2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 17:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, dwmw2@infradead.org, haavard.skinnemoen@atmel.com, linux@maxim.org.za


The patch titled
     MTD: atmel_nand can be modular
has been added to the -mm tree.  Its filename is
     mtd-atmel_nand-can-be-modular.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
rtc_read_alarm-handles-wraparound.patch
spi-spi_mpc83xx-clockrate-fixes.patch
gpio-pca953x-i2c-handles-max7310-too.patch
spi-fix-the-read-path-in-spidev.patch
spi-fix-the-read-path-in-spidev-cleanup.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
atmel_nand-speedup-via-readwritesbw.patch
mtd-atmel_nand-can-be-modular.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
spi-au1550_spi-proper-platform-device.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
rtc-remove-bkl-for-ioctl.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch

