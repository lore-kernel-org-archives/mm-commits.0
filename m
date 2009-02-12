From: akpm@linux-foundation.org
Subject: [merged] rtc-update-maintainership-of-pxa-rtc-driver.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:04 -0800
Message-ID: <200902122025.n1CKP4pk014127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610AbZBLUZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:25:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.jarzmik@free.fr, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: update maintainership of pxa rtc driver
has been removed from the -mm tree.  Its filename was
     rtc-update-maintainership-of-pxa-rtc-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: update maintainership of pxa rtc driver
From: Robert Jarzmik <robert.jarzmik@free.fr>

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS           |    6 ++++++
 drivers/rtc/rtc-pxa.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~rtc-update-maintainership-of-pxa-rtc-driver MAINTAINERS
--- a/MAINTAINERS~rtc-update-maintainership-of-pxa-rtc-driver
+++ a/MAINTAINERS
@@ -3537,6 +3537,12 @@ S:	Maintained
 PXA MMCI DRIVER
 S:	Orphan
 
+PXA RTC DRIVER
+P:	Robert Jarzmik
+M:	robert.jarzmik@free.fr
+L:	rtc-linux@googlegroups.com
+S:	Maintained
+
 QLOGIC QLA2XXX FC-SCSI DRIVER
 P:	Andrew Vasquez
 M:	linux-driver@qlogic.com
diff -puN drivers/rtc/rtc-pxa.c~rtc-update-maintainership-of-pxa-rtc-driver drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-update-maintainership-of-pxa-rtc-driver
+++ a/drivers/rtc/rtc-pxa.c
@@ -485,7 +485,7 @@ static void __exit pxa_rtc_exit(void)
 module_init(pxa_rtc_init);
 module_exit(pxa_rtc_exit);
 
-MODULE_AUTHOR("Robert Jarzmik");
+MODULE_AUTHOR("Robert Jarzmik <robert.jarzmik@free.fr>");
 MODULE_DESCRIPTION("PXA27x/PXA3xx Realtime Clock Driver (RTC)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pxa-rtc");
_

Patches currently in -mm which might be from robert.jarzmik@free.fr are

origin.patch
linux-next.patch

