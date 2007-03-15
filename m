From: akpm@linux-foundation.org
Subject: - maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:51 -0800
Message-ID: <200703152159.l2FLxpM2027845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42687 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbXCOWA4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@arlott.org, baldrick@free.fr, greg@kroah.com, simon@fire.lp0.eu, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: cxacru
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
