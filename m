From: akpm@linux-foundation.org
Subject: + maintainers-remove-drivers-video-epson1355fbc.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:11 -0800
Message-ID: <20121221215912.8FCAA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60283 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:15 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so275335eei.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, ch@hpl.hp.com, ch@murgatroid.com


The patch titled
     Subject: MAINTAINERS: remove drivers/video/epson1355fb.c
has been added to the -mm tree.  Its filename is
     maintainers-remove-drivers-video-epson1355fbc.patch

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
Subject: MAINTAINERS: remove drivers/video/epson1355fb.c

This driver was removed by commit 1c3a918 ("ARM: clps711x: Remove board
support for CEIVA").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Christopher Hoover <ch@murgatroid.com>
Cc: Christopher Hoover <ch@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-drivers-video-epson1355fbc MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drivers-video-epson1355fbc
+++ a/MAINTAINERS
@@ -2944,12 +2944,6 @@ M:	Maxim Levitsky <maximlevitsky@gmail.c
 S:	Maintained
 F:	drivers/media/rc/ene_ir.*
 
-EPSON 1355 FRAMEBUFFER DRIVER
-M:	Christopher Hoover <ch@murgatroid.com>
-M:	Christopher Hoover <ch@hpl.hp.com>
-S:	Maintained
-F:	drivers/video/epson1355fb.c
-
 EPSON S1D13XXX FRAMEBUFFER DRIVER
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
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

