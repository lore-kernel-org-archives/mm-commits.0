From: akpm@linux-foundation.org
Subject: + maintainers-remove-drivers-mmc-host-imxmmc.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:32 -0800
Message-ID: <20121221215933.A6293200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56556 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2LUV7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:35 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so275352eei.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, pisa@cmp.felk.cvut.cz, s.hauer@pengutronix.de


The patch titled
     Subject: MAINTAINERS: remove drivers/mmc/host/imxmmc.*
has been added to the -mm tree.  Its filename is
     maintainers-remove-drivers-mmc-host-imxmmc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove drivers/mmc/host/imxmmc.*

This driver was removed by commit 6187fee ("mmc: remove imxmmc driver").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-drivers-mmc-host-imxmmc MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drivers-mmc-host-imxmmc
+++ a/MAINTAINERS
@@ -5053,12 +5053,6 @@ F:	Documentation/video4linux/meye.txt
 F:	drivers/media/pci/meye/
 F:	include/uapi/linux/meye.h
 
-MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
-M:	Pavel Pisa <ppisa@pikron.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	drivers/mmc/host/imxmmc.*
-
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
maintainers-remove-drivers-platform-msm.patch
maintainers-remove-arch-arm-common-time-acornc.patch
maintainers-remove-arch-arm-plat-s5p.patch
maintainers-fix-drivers-rtc-rtc-vt8500c.patch
maintainers-fix-arch-arm-mach-at91-include-mach-at_hdmach.patch
maintainers-fix-drivers-media-platform-atmel-isic.patch
maintainers-adjust-for-uapi.patch
maintainers-fix-drivers-media-usb-dvb-usb-cxusb.patch
maintainers-remove-drivers-video-epson1355fbc.patch
maintainers-fix-plat-mxc-include-mach-imxfbh.patch
maintainers-fix-drivers-ieee802154.patch
maintainers-remove-firmware-isci.patch
maintainers-remove-arch-x86-platform-mrst-pmu.patch
maintainers-fix-documentation-mei.patch
maintainers-remove-drivers-mmc-host-imxmmc.patch
maintainers-remove-arch-lib-perf_eventc.patch
maintainers-remove-include-linux-of_pwmh.patch
maintainers-fix-drivers-staging-sm7xx.patch
linux-next.patch

