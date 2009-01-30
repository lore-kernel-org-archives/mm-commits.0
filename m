From: akpm@linux-foundation.org
Subject: + rtc-update-maintainership-of-pxa-rtc-driver.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:46:20 -0800
Message-ID: <200901302046.n0UKkKJH012039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbZA3Uq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert.jarzmik@free.fr, a.zummo@towertech.it


The patch titled
     rtc: update maintainership of pxa rtc driver
has been added to the -mm tree.  Its filename is
     rtc-update-maintainership-of-pxa-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3566,6 +3566,12 @@ S:	Maintained
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

linux-next.patch
rtc-update-maintainership-of-pxa-rtc-driver.patch

