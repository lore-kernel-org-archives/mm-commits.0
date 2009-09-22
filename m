From: akpm@linux-foundation.org
Subject: [merged] maintainers-move-arm-lists-to-infradead.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:27 -0700
Message-ID: <200909222045.n8MKjR9E015739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbZIVUpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, khc@pm.waw.pl, rmk@arm.linux.org.uk, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: move ARM lists to infradead
has been removed from the -mm tree.  Its filename was
     maintainers-move-arm-lists-to-infradead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: move ARM lists to infradead
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |  106 +++++++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff -puN MAINTAINERS~maintainers-move-arm-lists-to-infradead MAINTAINERS
--- a/MAINTAINERS~maintainers-move-arm-lists-to-infradead
+++ a/MAINTAINERS
@@ -498,7 +498,7 @@ F:	arch/arm/include/asm/floppy.h
 
 ARM PORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/
@@ -509,36 +509,36 @@ F:	drivers/mmc/host/mmci.*
 
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ixp23xx/
 F:	arch/arm/mach-ixp23xx/include/mach/
 
 ARM/ADS SPHERE MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/AFEB9260 MACHINE SUPPORT
 M:	Sergey Lapin <slapin@ossfans.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/AJECO 1ARM MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 M:	Andrew Victor <linux@maxim.org.za>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://maxim.org.za/at91_26.html
 S:	Maintained
 
 ARM/BCMRING ARM ARCHITECTURE
 M:	Leo Chen <leochen@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-bcmring
 
@@ -555,25 +555,25 @@ F:	drivers/mtd/nand/nand_bcm_umi.h
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 M:	Hartley Sweeten <hsweeten@visionengravers.com>
 M:	Ryan Mallon <ryan@bluewatersys.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ep93xx/
 F:	arch/arm/mach-ep93xx/include/mach/
 
 ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
 M:	Mike Rapoport <mike@compulab.co.il>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/CORGI MACHINE SUPPORT
@@ -582,14 +582,14 @@ S:	Maintained
 
 ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://gitorious.org/linux-gemini/mainline.git
 S:	Maintained
 F:	arch/arm/mach-gemini/
 
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/mach-ebsa110/
@@ -607,13 +607,13 @@ F:	arch/arm/mach-pxa/ezx.c
 
 ARM/FARADAY FA526 PORT
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/include/asm/hardware/dec21285.h
@@ -621,17 +621,17 @@ F:	arch/arm/mach-footbridge/
 
 ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
 M:	Sascha Hauer <kernel@pengutronix.de>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/GUMSTIX MACHINE SUPPORT
 M:	Steve Sakoman <sakoman@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/H4700 (HP IPAQ HX4700) MACHINE SUPPORT
@@ -651,55 +651,55 @@ F:	arch/arm/mach-sa1100/include/mach/jor
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IXP2000 ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IXDP2850 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IXP23XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/LOGICPD PXA270 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/MAGICIAN MACHINE SUPPORT
@@ -709,7 +709,7 @@ S:	Maintained
 ARM/Marvell Loki/Kirkwood/MV78xx0/Orion SOC support
 M:	Lennert Buytenhek <buytenh@marvell.com>
 M:	Nicolas Pitre <nico@marvell.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.marvell.com/orion
 S:	Maintained
 F:	arch/arm/mach-loki/
@@ -720,7 +720,7 @@ F:	arch/arm/plat-orion/
 
 ARM/MIOA701 MACHINE SUPPORT
 M:	Robert Jarzmik <robert.jarzmik@free.fr>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 F:	arch/arm/mach-pxa/mioa701.c
 S:	Maintained
 
@@ -761,18 +761,18 @@ S:	Maintained
 
 ARM/PT DIGITAL BOARD PORT
 M:	Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/RISCPC ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/common/time-acorn.c
@@ -791,7 +791,7 @@ S:	Maintained
 
 ARM/SAMSUNG ARM ARCHITECTURES
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-s3c/
@@ -799,65 +799,65 @@ F:	arch/arm/plat-s3c24xx/
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
 
 ARM/S3C2440 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
 
 ARM/S3C2442 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2442/
 
 ARM/S3C2443 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2443/
 
 ARM/S3C6400 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6400/
 
 ARM/S3C6410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/THECUS N2100 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/NUVOTON W90X900 ARM ARCHITECTURE
 M:	Wan ZongShun <mcuos.com@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.mcuos.com
 S:	Maintained
 
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
@@ -964,7 +964,7 @@ F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
@@ -1542,7 +1542,7 @@ F:	drivers/infiniband/hw/cxgb3/
 
 CYBERPRO FB DRIVER
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
@@ -2086,7 +2086,7 @@ F:	drivers/i2c/busses/i2c-cpm.c
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-mxc/include/mach/imxfb.h
 F:	drivers/video/imxfb.c
@@ -3452,7 +3452,7 @@ F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 M:	Pavel Pisa <ppisa@pikron.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/mmc/host/imxmmc.*
 
@@ -4170,7 +4170,7 @@ F:	drivers/media/video/pvrusb2/
 PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
@@ -4183,13 +4183,13 @@ F:	sound/soc/pxa
 PXA168 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Jason Chagas <jason.chagas@marvell.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
 PXA910 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
@@ -4430,7 +4430,7 @@ F:	net/iucv/
 
 S3C24XX SD/MMC Driver
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	drivers/mmc/host/s3cmci.*
 
@@ -4634,7 +4634,7 @@ F:	drivers/misc/sgi-xp/
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 F:	arch/arm/mach-lh7a40x/
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
ncpfs-remove-dead-url-from-documentation.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

