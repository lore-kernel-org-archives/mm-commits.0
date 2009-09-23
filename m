From: akpm@linux-foundation.org
Subject: [merged] gpio-pca953x-add-support-for-max7315.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:45 -0700
Message-ID: <200909231959.n8NJxjNX011651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbZIWT7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alek.du@intel.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: pca953x: add support for MAX7315
has been removed from the -mm tree.  Its filename was
     gpio-pca953x-add-support-for-max7315.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x: add support for MAX7315
From: Alek Du <alek.du@intel.com>

MAX7315 is pin and software compatible with PCA9534, so add it to the I2C
device ID table of pca953x driver. 
http://www.datasheetcatalog.org/datasheet/maxim/MAX7315.pdf

Signed-off-by: Alek Du <alek.du@intel.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-max7315 drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-max7315
+++ a/drivers/gpio/pca953x.c
@@ -40,6 +40,7 @@ static const struct i2c_device_id pca953
 	{ "pca9557", 8, },
 
 	{ "max7310", 8, },
+	{ "max7315", 8, },
 	{ "pca6107", 8, },
 	{ "tca6408", 8, },
 	{ "tca6416", 16, },
_

Patches currently in -mm which might be from alek.du@intel.com are

origin.patch
linux-next.patch

