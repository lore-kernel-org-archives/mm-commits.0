From: akpm@linux-foundation.org
Subject: + maintainers-remove-include-linux-of_pwmh.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:39 -0800
Message-ID: <20121221215940.2780C820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:45049 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2LUV7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:41 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so214920ghb.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, thierry.reding@avionic-design.de


The patch titled
     Subject: MAINTAINERS: remove include/linux/of_pwm.h
has been added to the -mm tree.  Its filename is
     maintainers-remove-include-linux-of_pwmh.patch

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
Subject: MAINTAINERS: remove include/linux/of_pwm.h

Added by commit 200efed ("pwm: Take over maintainership of the PWM
subsystem"), but I could not find any trace of that file being ever added
to the repository.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-include-linux-of_pwmh MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-include-linux-of_pwmh
+++ a/MAINTAINERS
@@ -6116,7 +6116,6 @@ T:	git git://gitorious.org/linux-pwm/lin
 F:	Documentation/pwm.txt
 F:	Documentation/devicetree/bindings/pwm/
 F:	include/linux/pwm.h
-F:	include/linux/of_pwm.h
 F:	drivers/pwm/
 F:	drivers/video/backlight/pwm_bl.c
 F:	include/linux/pwm_backlight.h
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

