From: akpm@linux-foundation.org
Subject: + maintainers-fix-drivers-rtc-rtc-vt8500c.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:58:58 -0800
Message-ID: <20121221215858.8DA04100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39121 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:58:59 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so526240qcq.5
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:58:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, linux@prisktech.co.nz


The patch titled
     Subject: MAINTAINERS: fix drivers/rtc/rtc-vt8500.c
has been added to the -mm tree.  Its filename is
     maintainers-fix-drivers-rtc-rtc-vt8500c.patch

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
Subject: MAINTAINERS: fix drivers/rtc/rtc-vt8500.c

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-rtc-rtc-vt8500c MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-rtc-rtc-vt8500c
+++ a/MAINTAINERS
@@ -1250,7 +1250,7 @@ F:	drivers/video/vt8500lcdfb.*
 F:	drivers/video/wm8505fb*
 F:	drivers/video/wmt_ge_rops.*
 F:	drivers/tty/serial/vt8500_serial.c
-F:	drivers/rtc/rtc-vt8500-c
+F:	drivers/rtc/rtc-vt8500.c
 F:	drivers/mmc/host/wmt-sdmmc.c
 
 ARM/ZIPIT Z2 SUPPORT
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

