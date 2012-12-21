From: akpm@linux-foundation.org
Subject: + maintainers-fix-drivers-staging-sm7xx.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:42 -0800
Message-ID: <20121221215943.9566820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:57093 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2LUV7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:45 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so275425wey.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, jmunhoz@igalia.com, teddy.wang@siliconmotion.com.cn


The patch titled
     Subject: MAINTAINERS: fix drivers/staging/sm7xx/
has been added to the -mm tree.  Its filename is
     maintainers-fix-drivers-staging-sm7xx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix drivers/staging/sm7xx/

This directory was moved to drivers/staging/sm7xxfb/ by commit 925aa66
("staging: sm7xxfb: sm7xx becomes sm7xxfb").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>
Acked-by: Javier Mu=F1oz <jmunhoz@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-staging-sm7xx MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-staging-sm7xx
+++ a/MAINTAINERS
@@ -7297,7 +7297,7 @@ F:	drivers/staging/rtl8712/
 STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
 M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
 S:	Odd Fixes
-F:	drivers/staging/sm7xx/
+F:	drivers/staging/sm7xxfb/
=20
 STAGING - SOFTLOGIC 6x10 MPEG CODEC
 M:	Ben Collins <bcollins@bluecherry.net>
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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
