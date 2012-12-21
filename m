From: akpm@linux-foundation.org
Subject: + maintainers-fix-drivers-ieee802154.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:19 -0800
Message-ID: <20121221215920.365DA82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:63903 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:21 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so526213yhr.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com


The patch titled
     Subject: MAINTAINERS: fix drivers/ieee802154/
has been added to the -mm tree.  Its filename is
     maintainers-fix-drivers-ieee802154.patch

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
Subject: MAINTAINERS: fix drivers/ieee802154/

This directory was moved to drivers/net/ieee802154/ by commit 31d178b
("drivers/ieee802154: move ieee802154 drivers to net folder").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-ieee802154 MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-ieee802154
+++ a/MAINTAINERS
@@ -3868,7 +3868,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	net/ieee802154/
 F:	net/mac802154/
-F:	drivers/ieee802154/
+F:	drivers/net/ieee802154/
 
 IGUANAWORKS USB IR TRANSCEIVER
 M:	Sean Young <sean@mess.org>
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

