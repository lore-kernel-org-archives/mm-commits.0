From: akpm@osdl.org
Subject: + fix-s3c24xx-gpio-driver-include-linux-workqueueh.patch added to -mm tree
Date: Thu, 21 Dec 2006 01:56:50 -0800
Message-ID: <200612210956.kBL9uoJm023420@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54424 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965186AbWLUJ5c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 04:57:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     fix s3c24xx gpio driver (include linux/workqueue.h)
has been added to the -mm tree.  Its filename is
     fix-s3c24xx-gpio-driver-include-linux-workqueueh.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix s3c24xx gpio driver (include linux/workqueue.h)
From: Ben Dooks <ben-linux@fluff.org>

The general gpio driver includes seem to now depend on having
<linux/workqueue.h> included before they are.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi_s3c24xx_gpio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/spi/spi_s3c24xx_gpio.c~fix-s3c24xx-gpio-driver-include-linux-workqueueh drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~fix-s3c24xx-gpio-driver-include-linux-workqueueh
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/platform_device.h>
 
 #include <linux/spi/spi.h>
_

Patches currently in -mm which might be from ben-linux@fluff.org are

maintainers-fix-email-for-s3c2410-and-s3c2440.patch
fix-s3c24xx-gpio-driver-include-linux-workqueueh.patch
git-watchdog.patch

