From: akpm@linux-foundation.org
Subject: + maintainers-fix-drivers-media-usb-dvb-usb-cxusb.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:09 -0800
Message-ID: <20121221215909.F321882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:47558 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:11 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so526715yhr.0
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, mkrufky@linuxtv.org


The patch titled
     Subject: MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*
has been added to the -mm tree.  Its filename is
     maintainers-fix-drivers-media-usb-dvb-usb-cxusb.patch

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
Subject: MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*

This driver was never at dvb-usb-v2, as far as I could see.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-media-usb-dvb-usb-cxusb MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-media-usb-dvb-usb-cxusb
+++ a/MAINTAINERS
@@ -2632,7 +2632,7 @@ W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
-F:	drivers/media/usb/dvb-usb-v2/cxusb*
+F:	drivers/media/usb/dvb-usb/cxusb*
 
 DVB_USB_CYPRESS_FIRMWARE MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
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

