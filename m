From: akpm@linux-foundation.org
Subject: + maintainers-remove-firmware-isci.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:59:22 -0800
Message-ID: <20121221215923.62926100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33960 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:59:24 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so526274qcq.5
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:59:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, JBottomley@Parallels.com, ben@decadent.org.uk, dan.j.williams@intel.com, dave.jiang@intel.com, intel-linux-scu@intel.com, lukasz.dorau@intel.com, maciej.patelczyk@intel.com


The patch titled
     Subject: MAINTAINERS: remove firmware/isci/
has been added to the -mm tree.  Its filename is
     maintainers-remove-firmware-isci.patch

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
Subject: MAINTAINERS: remove firmware/isci/

This directory was removed by commit 7d99b3a ("isci, firmware: Remove isci
fallback parameter blob and generator").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-firmware-isci MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-firmware-isci
+++ a/MAINTAINERS
@@ -3961,7 +3961,6 @@ L:	linux-scsi@vger.kernel.org
 T:	git git://git.code.sf.net/p/intel-sas/isci
 S:	Supported
 F:	drivers/scsi/isci/
-F:	firmware/isci/
 
 INTEL IDLE DRIVER
 M:	Len Brown <lenb@kernel.org>
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

