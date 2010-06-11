From: akpm@linux-foundation.org
Subject: + maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:12:15 -0700
Message-ID: <201006112012.o5BKCFrc016972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316Ab0FKUMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mcuos.com@gmail.com


The patch titled
     MAINTAINERS: update ARM/NUVOTON W90X900 ARM ARCHITECTURE file patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update ARM/NUVOTON W90X900 ARM ARCHITECTURE file patterns
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns
+++ a/MAINTAINERS
@@ -977,12 +977,11 @@ F:	drivers/input/keyboard/w90p910_keypad
 F:	drivers/input/touchscreen/w90p910_ts.c
 F:	drivers/watchdog/nuc900_wdt.c
 F:	drivers/net/arm/w90p910_ether.c
-F:	drivers/mtd/nand/w90p910_nand.c
+F:	drivers/mtd/nand/nuc900_nand.c
 F:	drivers/rtc/rtc-nuc900.c
 F:	drivers/spi/spi_nuc900.c
 F:	drivers/usb/host/ehci-w90x900.c
 F:	drivers/video/nuc900fb.c
-F:	drivers/sound/soc/nuc900/
 
 ARM/U300 MACHINE SUPPORT
 M:	Linus Walleij <linus.walleij@stericsson.com>
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
kernelh-remove-unused-nipquad-and-nipquad_fmt.patch
maintainers-update-arm-bcmring-mtd-nand-driver-file-patterns.patch
maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch
maintainers-update-arm-voipac-pxa270-file-patterns.patch
maintainers-update-arm-zipit-z2-support-file-patterns.patch
maintainers-update-networking-file-patterns.patch
maintainers-update-ppp-over-l2tp-file-patterns.patch
maintainers-update-ricoh-smartmedia-xd-driver-file-patterns.patch
maintainers-remove-section-smx-uio-interface.patch
maintainers-update-spear-clock-framework-support-file-patterns.patch
maintainers-remove-section-strip.patch
maintainers-remove-section-wavelan-network-driver-wireless-extensions.patch
documentation-networking-wavelantxt-deleted-not-in-tree.patch

