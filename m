From: akpm@linux-foundation.org
Subject: + rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:23:33 -0800
Message-ID: <200901302023.n0UKNXKc016149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbZA3UXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mkatiyar@gmail.com, a.zummo@towertech.it


The patch titled
     rtc-ds1390: fix compilation warnings in drivers/rtc/rtc-ds1390.c
has been added to the -mm tree.  Its filename is
     rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c.patch

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
Subject: rtc-ds1390: fix compilation warnings in drivers/rtc/rtc-ds1390.c
From: Manish Katiyar <mkatiyar@gmail.com>

drivers/rtc/rtc-ds1390.c:125: warning: unused variable 'rtc'

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1390.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1390.c~rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c
+++ a/drivers/rtc/rtc-ds1390.c
@@ -122,7 +122,6 @@ static const struct rtc_class_ops ds1390
 
 static int __devinit ds1390_probe(struct spi_device *spi)
 {
-	struct rtc_device *rtc;
 	unsigned char tmp;
 	struct ds1390 *chip;
 	int res;
_

Patches currently in -mm which might be from mkatiyar@gmail.com are

rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c.patch
nfs-nfs-and-nfsd-should-depend-upon-config_file_locking.patch

