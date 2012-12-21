From: akpm@linux-foundation.org
Subject: + maintainers-remove-arch-x86-platform-mrst-pmu.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:25 -0800
Message-ID: <20121221215926.98BAB20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:64538 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:29 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so275365wib.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, alan@linux.intel.com, len.brown@intel.com


The patch titled
     Subject: MAINTAINERS: remove arch/x86/platform/mrst/pmu.*
has been added to the -mm tree.  Its filename is
     maintainers-remove-arch-x86-platform-mrst-pmu.patch

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
Subject: MAINTAINERS: remove arch/x86/platform/mrst/pmu.*

These files were removed by commit 1a8359e ("x86/mid: Remove Intel
Moorestown").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-arch-x86-platform-mrst-pmu MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arch-x86-platform-mrst-pmu
+++ a/MAINTAINERS
@@ -4055,12 +4055,6 @@ F:	Documentation/networking/ixgbe.txt
 F:	Documentation/networking/ixgbevf.txt
 F:	drivers/net/ethernet/intel/
 
-INTEL MRST PMU DRIVER
-M:	Len Brown <len.brown@intel.com>
-L:	linux-pm@vger.kernel.org
-S:	Supported
-F:	arch/x86/platform/mrst/pmu.*
-
 INTEL PRO/WIRELESS 2100, 2200BG, 2915ABG NETWORK CONNECTION SUPPORT
 M:	Stanislav Yakovlev <stas.yakovlev@gmail.com>
 L:	linux-wireless@vger.kernel.org
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

