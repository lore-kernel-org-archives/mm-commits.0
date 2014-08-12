From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-usb-gadget-patterns.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:44:15 -0700
Message-ID: <53ea6e8f.cyGzIwWN0v3jjImi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53935 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaHLToQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:44:16 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so473079qcx.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:44:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andrzej.p@samsung.com, dahlmann.thomas@arcor.de, eric.y.miao@gmail.com, haojian.zhuang@gmail.com, laurent.pinchart@ideasonboard.com, leoli@freescale.com, linux@arm.linux.org.uk, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update usb/gadget patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-usb-gadget-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update usb/gadget patterns

Several commits have moved files around, update the section patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~maintainers-update-usb-gadget-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-usb-gadget-patterns
+++ a/MAINTAINERS
@@ -597,7 +597,7 @@ AMD GEODE CS5536 USB DEVICE CONTROLLER D
 M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/usb/gadget/amd5536udc.*
+F:	drivers/usb/gadget/udc/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Andres Salomon <dilinger@queued.net>
@@ -1690,7 +1690,7 @@ ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/usb/gadget/atmel_usba_udc.*
+F:	drivers/usb/gadget/udc/atmel_usba_udc.*
 
 ATMEL WIRELESS DRIVER
 M:	Simon Kelley <simon@thekelleys.org.uk>
@@ -3800,7 +3800,7 @@ M:	Li Yang <leoli@freescale.com>
 L:	linux-usb@vger.kernel.org
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Maintained
-F:	drivers/usb/gadget/fsl*
+F:	drivers/usb/gadget/udc/fsl*
 
 FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
 M:	Li Yang <leoli@freescale.com>
@@ -7228,7 +7228,7 @@ S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
 F:	drivers/spi/spi-pxa2xx*
-F:	drivers/usb/gadget/pxa2*
+F:	drivers/usb/gadget/udc/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
 F:	sound/soc/pxa/
@@ -9582,8 +9582,8 @@ USB WEBCAM GADGET
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
-F:	drivers/usb/gadget/*uvc*.c
-F:	drivers/usb/gadget/webcam.c
+F:	drivers/usb/gadget/function/*uvc*.c
+F:	drivers/usb/gadget/legacy/webcam.c
 
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
 M:	Jussi Kivilinna <jussi.kivilinna@iki.fi>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

