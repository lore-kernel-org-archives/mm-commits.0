From: akpm@linux-foundation.org
Subject: + maintainers-fix-plat-mxc-include-mach-imxfbh.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:15 -0800
Message-ID: <20121221215916.8CC32200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:56479 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2LUV7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:18 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so275388wey.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, s.hauer@pengutronix.de


The patch titled
     Subject: MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
has been added to the -mm tree.  Its filename is
     maintainers-fix-plat-mxc-include-mach-imxfbh.patch

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
Subject: MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h

This file was moved to include/linux/platform_data/video-imxfb.h by
commit 82906b1 ("ARM: imx: move platform_data definitions").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-plat-mxc-include-mach-imxfbh MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-plat-mxc-include-mach-imxfbh
+++ a/MAINTAINERS
@@ -3207,7 +3207,7 @@ M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/plat-mxc/include/mach/imxfb.h
+F:	include/linux/platform_data/video-imxfb.h
 F:	drivers/video/imxfb.c
 
 FREESCALE SOC FS_ENET DRIVER
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

