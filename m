From: akpm@linux-foundation.org
Subject: + maintainers-remove-drivers-platform-msm.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:58:48 -0800
Message-ID: <20121221215849.7584682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:53376 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2LUV6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:58:50 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so526220ggm.0
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:58:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, bryanh@codeaurora.org, davidb@codeaurora.org, dwalker@fifo99.com, kheitke@codeaurora.org


The patch titled
     Subject: MAINTAINERS: remove drivers/platform/msm/
has been added to the -mm tree.  Its filename is
     maintainers-remove-drivers-platform-msm.patch

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
Subject: MAINTAINERS: remove drivers/platform/msm/

Added by commit 8a5700c ("add drivers/platform/msm to MSM subsystem") in
2011, but I could not find any trace of that directory being ever added to
the repository.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Kenneth Heitke <kheitke@codeaurora.org>
Acked-by: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-drivers-platform-msm MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drivers-platform-msm
+++ a/MAINTAINERS
@@ -1005,7 +1005,6 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
-F:	drivers/platform/msm/
 F:	drivers/*/pm8???-*
 F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
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

