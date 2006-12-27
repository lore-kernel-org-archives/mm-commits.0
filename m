From: akpm@osdl.org
Subject: + spi_s3c24xx_gpio-use-right-header.patch added to -mm tree
Date: Wed, 27 Dec 2006 14:25:52 -0800
Message-ID: <200612272225.kBRMPqxk021658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39220 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785AbWL0W0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 17:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net


The patch titled
     spi_s3c24xx_gpio: use right header
has been added to the -mm tree.  Its filename is
     spi_s3c24xx_gpio-use-right-header.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

spi_s3c24xx_gpio-use-right-header.patch

