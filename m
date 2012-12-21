From: akpm@linux-foundation.org
Subject: + maintainers-remove-arch-arm-plat-s5p.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:58:53 -0800
Message-ID: <20121221215854.80C3020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:52654 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:58:57 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so262325lag.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:58:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, ben-linux@fluff.org, kgene.kim@samsung.com


The patch titled
     Subject: MAINTAINERS: remove arch/arm/plat-s5p/
has been added to the -mm tree.  Its filename is
     maintainers-remove-arch-arm-plat-s5p.patch

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
Subject: MAINTAINERS: remove arch/arm/plat-s5p/

These files were merged into plat-samsung.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Ben Dooks <ben-linux@fluff.org>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-arch-arm-plat-s5p MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arch-arm-plat-s5p
+++ a/MAINTAINERS
@@ -1092,7 +1092,6 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-samsung/
 F:	arch/arm/plat-s3c24xx/
-F:	arch/arm/plat-s5p/
 F:	arch/arm/mach-s3c24*/
 F:	arch/arm/mach-s3c64xx/
 F:	drivers/*/*s3c2410*
@@ -1123,7 +1122,6 @@ M:	Sylwester Nawrocki <s.nawrocki@samsun
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-fimc*
 F:	arch/arm/plat-samsung/include/plat/*fimc*
 F:	drivers/media/platform/s5p-fimc/
 
@@ -1134,7 +1132,7 @@ M:	Jeongtae Park <jtp.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-mfc.c
+F:	arch/arm/plat-samsung/s5p-dev-mfc.c
 F:	drivers/media/platform/s5p-mfc/
 
 ARM/SAMSUNG S5P SERIES TV SUBSYSTEM SUPPORT
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

