From: akpm@linux-foundation.org
Subject: [merged] gpio-pca953x-add-support-for-pca9556.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:40 -0700
Message-ID: <200906182244.n5IMieTE003771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758873AbZFRWok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ncase@xes-inc.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: pca953x: Add support for PCA9556
has been removed from the -mm tree.  Its filename was
     gpio-pca953x-add-support-for-pca9556.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x: Add support for PCA9556
From: Nate Case <ncase@xes-inc.com>

PCA9556 is the software-compatible predecessor to the PCA9557, so add it
to the supported I2C device ID table.

Signed-off-by: Nate Case <ncase@xes-inc.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9556 drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9556
+++ a/drivers/gpio/pca953x.c
@@ -36,6 +36,7 @@ static const struct i2c_device_id pca953
 	{ "pca9539", 16, },
 	{ "pca9554", 8, },
 	{ "pca9555", 16, },
+	{ "pca9556", 8, },
 	{ "pca9557", 8, },
 
 	{ "max7310", 8, },
_

Patches currently in -mm which might be from ncase@xes-inc.com are

origin.patch
linux-next.patch

