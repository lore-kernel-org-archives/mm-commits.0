From: akpm@linux-foundation.org
Subject: + maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:51:01 -0800
Message-ID: <200702272051.l1RKp5HT028115@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbXB0Uvd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@arlott.org, baldrick@free.fr, greg@kroah.com, simon@fire.lp0.eu


The patch titled
     MAINTAINERS: cxacru
has been added to the -mm tree.  Its filename is
     maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS: cxacru
From: Simon Arlott <simon@arlott.org>

I've acquired a second device for testing and plan to make some changes in
the near future to export all the device stats to sysfs (based on my
proposed patch to add them to the proc file ~2007-01-30).

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Acked-by: Duncan Sands <baldrick@free.fr>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-add-myself-for-cxacru-in-drivers-usb-atm MAINTAINERS
--- a/MAINTAINERS~maintainers-add-myself-for-cxacru-in-drivers-usb-atm
+++ a/MAINTAINERS
@@ -952,6 +952,11 @@ M:	mhw@wittsend.com
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
 
+CONEXANT ACCESSRUNNER USB DRIVER
+P:	Simon Arlott
+M:	cxacru@fire.lp0.eu
+S:	Maintained
+
 COSA/SRP SYNC SERIAL DRIVER
 P:	Jan "Yenya" Kasprzak
 M:	kas@fi.muni.cz
_

Patches currently in -mm which might be from simon@arlott.org are

usbatm-create-sysfs-link-device-from-atm-class-device.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
cxacru-export-detailed-device-info-through-sysfs-updated.patch
maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch
