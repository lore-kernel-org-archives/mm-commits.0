From: akpm@linux-foundation.org
Subject: + arch-arm-removed-duplicate-includes.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:35:46 -0800
Message-ID: <200711060235.lA62ZkfL032018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbXKFCf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:35:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodzy@gmail.com, buytenh@wantstofly.org, rmk@arm.linux.org.uk


The patch titled
     arch/arm: remove duplicate includes
has been added to the -mm tree.  Its filename is
     arch-arm-removed-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/arm: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/rtctime.c            |    1 -
 arch/arm/mach-ep93xx/core.c          |    1 -
 arch/arm/mach-ixp23xx/core.c         |    1 -
 arch/arm/mach-ixp23xx/espresso.c     |    2 --
 arch/arm/mach-ixp23xx/ixdp2351.c     |    2 --
 arch/arm/mach-ixp23xx/roadrunner.c   |    2 --
 arch/arm/mach-ixp4xx/nslu2-power.c   |    1 -
 arch/arm/mach-omap1/board-nokia770.c |    1 -
 arch/arm/mach-omap1/board-osk.c      |    1 -
 arch/arm/mach-omap1/board-palmtt.c   |    1 -
 arch/arm/mach-omap1/board-palmz71.c  |    1 -
 arch/arm/mach-omap2/board-apollon.c  |    1 -
 12 files changed, 15 deletions(-)

diff -puN arch/arm/common/rtctime.c~arch-arm-removed-duplicate-includes arch/arm/common/rtctime.c
--- a/arch/arm/common/rtctime.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/common/rtctime.c
@@ -20,7 +20,6 @@
 #include <linux/capability.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
-#include <linux/rtc.h>
 
 #include <asm/rtc.h>
 #include <asm/semaphore.h>
diff -puN arch/arm/mach-ep93xx/core.c~arch-arm-removed-duplicate-includes arch/arm/mach-ep93xx/core.c
--- a/arch/arm/mach-ep93xx/core.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-ep93xx/core.c
@@ -21,7 +21,6 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/bitops.h>
-#include <linux/serial.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_core.h>
 #include <linux/device.h>
diff -puN arch/arm/mach-ixp23xx/core.c~arch-arm-removed-duplicate-includes arch/arm/mach-ixp23xx/core.c
--- a/arch/arm/mach-ixp23xx/core.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-ixp23xx/core.c
@@ -22,7 +22,6 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/bitops.h>
-#include <linux/serial.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_core.h>
 #include <linux/device.h>
diff -puN arch/arm/mach-ixp23xx/espresso.c~arch-arm-removed-duplicate-includes arch/arm/mach-ixp23xx/espresso.c
--- a/arch/arm/mach-ixp23xx/espresso.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-ixp23xx/espresso.c
@@ -19,7 +19,6 @@
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
-#include <linux/serial.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_core.h>
 #include <linux/device.h>
@@ -40,7 +39,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/irq.h>
 #include <asm/mach/pci.h>
 
 static int __init espresso_pci_init(void)
diff -puN arch/arm/mach-ixp23xx/ixdp2351.c~arch-arm-removed-duplicate-includes arch/arm/mach-ixp23xx/ixdp2351.c
--- a/arch/arm/mach-ixp23xx/ixdp2351.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -24,7 +24,6 @@
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
-#include <linux/serial.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_core.h>
 #include <linux/device.h>
@@ -44,7 +43,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/irq.h>
 #include <asm/mach/pci.h>
 
 /*
diff -puN arch/arm/mach-ixp23xx/roadrunner.c~arch-arm-removed-duplicate-includes arch/arm/mach-ixp23xx/roadrunner.c
--- a/arch/arm/mach-ixp23xx/roadrunner.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-ixp23xx/roadrunner.c
@@ -23,7 +23,6 @@
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
-#include <linux/serial.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_core.h>
 #include <linux/device.h>
@@ -44,7 +43,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/irq.h>
 #include <asm/mach/pci.h>
 
 /*
diff -puN arch/arm/mach-ixp4xx/nslu2-power.c~arch-arm-removed-duplicate-includes arch/arm/mach-ixp4xx/nslu2-power.c
--- a/arch/arm/mach-ixp4xx/nslu2-power.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-ixp4xx/nslu2-power.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/reboot.h>
 
 #include <asm/mach-types.h>
 
diff -puN arch/arm/mach-omap1/board-nokia770.c~arch-arm-removed-duplicate-includes arch/arm/mach-omap1/board-nokia770.c
--- a/arch/arm/mach-omap1/board-nokia770.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-omap1/board-nokia770.c
@@ -32,7 +32,6 @@
 #include <asm/arch/common.h>
 #include <asm/arch/dsp_common.h>
 #include <asm/arch/aic23.h>
-#include <asm/arch/gpio.h>
 #include <asm/arch/omapfb.h>
 #include <asm/arch/lcd_mipid.h>
 
diff -puN arch/arm/mach-omap1/board-osk.c~arch-arm-removed-duplicate-includes arch/arm/mach-omap1/board-osk.c
--- a/arch/arm/mach-omap1/board-osk.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-omap1/board-osk.c
@@ -31,7 +31,6 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/interrupt.h>
 #include <linux/i2c.h>
 
 #include <linux/mtd/mtd.h>
diff -puN arch/arm/mach-omap1/board-palmtt.c~arch-arm-removed-duplicate-includes arch/arm/mach-omap1/board-palmtt.c
--- a/arch/arm/mach-omap1/board-palmtt.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-omap1/board-palmtt.c
@@ -42,7 +42,6 @@
 #include <asm/arch/common.h>
 #include <asm/arch/omap-alsa.h>
 
-#include <linux/input.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 
diff -puN arch/arm/mach-omap1/board-palmz71.c~arch-arm-removed-duplicate-includes arch/arm/mach-omap1/board-palmz71.c
--- a/arch/arm/mach-omap1/board-palmz71.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-omap1/board-palmz71.c
@@ -44,7 +44,6 @@
 #include <asm/arch/common.h>
 #include <asm/arch/omap-alsa.h>
 
-#include <linux/input.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 
diff -puN arch/arm/mach-omap2/board-apollon.c~arch-arm-removed-duplicate-includes arch/arm/mach-omap2/board-apollon.c
--- a/arch/arm/mach-omap2/board-apollon.c~arch-arm-removed-duplicate-includes
+++ a/arch/arm/mach-omap2/board-apollon.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/leds.h>
-#include <linux/irq.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-alpha-removed-duplicate-includes.patch
arch-arm-removed-duplicate-includes.patch
arch-ia64-remove-duplicate-includes.patch
arch-mips-remove-duplicate-includes.patch
arch-parisc-remove-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
arch-sparc-remove-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
