From: akpm@osdl.org
Subject: - fix-s3c24xx-gpio-driver-include-linux-workqueueh.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:55:04 -0800
Message-ID: <200612230755.kBN7t4KK010268@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49883 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbWLWHzp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:55:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     fix s3c24xx gpio driver (include linux/workqueue.h)
has been removed from the -mm tree.  Its filename was
     fix-s3c24xx-gpio-driver-include-linux-workqueueh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-watchdog.patch

