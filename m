From: akpm@osdl.org
Subject: - spi_s3c24xx_gpio-use-right-header.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:55 -0800
Message-ID: <200701020724.l027Ot23012992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37392 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbXABHZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:25:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx_gpio: use right header
has been removed from the -mm tree.  Its filename was
     spi_s3c24xx_gpio-use-right-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_s3c24xx_gpio: use right header
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>

Russel King recently reminded us that one shouldn't use asm/arch/hardware.h
but one should use asm/hardware.h.  Unfortunately, the spi_s3c24xx_gpio
driver is using the wrong header.  This patch is fixing that.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi_s3c24xx_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_s3c24xx_gpio.c~spi_s3c24xx_gpio-use-right-header drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~spi_s3c24xx_gpio-use-right-header
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -23,7 +23,7 @@
 
 #include <asm/arch/regs-gpio.h>
 #include <asm/arch/spi-gpio.h>
-#include <asm/arch/hardware.h>
+#include <asm/hardware.h>
 
 struct s3c2410_spigpio {
 	struct spi_bitbang		 bitbang;
_

Patches currently in -mm which might be from arnaud.patard@rtp-net.org are
