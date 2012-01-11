From: akpm@linux-foundation.org
Subject: [merged] maintainers-spi-update-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:36 -0800
Message-ID: <20120111212937.05E9720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33294 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2AKV3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:39 -0500
Received: by werf1 with SMTP id f1so53608wer.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: spi: update F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-spi-update-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: spi: update F: patterns

commit ca632f55669 ("spi: reorganize drivers") renamed the files, update
the F: patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-spi-update-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-spi-update-f-patterns
+++ a/MAINTAINERS
@@ -1144,7 +1144,7 @@ F:	drivers/watchdog/nuc900_wdt.c
 F:	drivers/net/ethernet/nuvoton/w90p910_ether.c
 F:	drivers/mtd/nand/nuc900_nand.c
 F:	drivers/rtc/rtc-nuc900.c
-F:	drivers/spi/spi_nuc900.c
+F:	drivers/spi/spi-nuc900.c
 F:	drivers/usb/host/ehci-w90x900.c
 F:	drivers/video/nuc900fb.c
 
@@ -1348,7 +1348,7 @@ F:	drivers/net/ethernet/cadence/
 ATMEL SPI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
-F:	drivers/spi/atmel_spi.*
+F:	drivers/spi/spi-atmel.*
 
 ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
@@ -5308,7 +5308,7 @@ T:	git git://git.linaro.org/people/ycmia
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
-F:	drivers/spi/pxa2xx*
+F:	drivers/spi/spi-pxa2xx*
 F:	drivers/usb/gadget/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

