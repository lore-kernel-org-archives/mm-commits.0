From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:18 -0800
Message-ID: <200902061938.n16JcIdC012165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728AbZBFTi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mkatiyar@gmail.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1390: fix compilation warnings in drivers/rtc/rtc-ds1390.c
has been removed from the -mm tree.  Its filename was
     rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

