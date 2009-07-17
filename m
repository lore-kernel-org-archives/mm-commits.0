From: akpm@linux-foundation.org
Subject: + gpio-pca953x-add-support-for-max7315.patch added to -mm tree
Date: Fri, 17 Jul 2009 16:50:12 -0700
Message-ID: <200907172350.n6HNoCOg006442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758046AbZGQXur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 19:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alek.du@intel.com, david-b@pacbell.net


The patch titled
     gpio: pca953x: add support for MAX7315
has been added to the -mm tree.  Its filename is
     gpio-pca953x-add-support-for-max7315.patch

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

gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch
gpio-pca953x-add-support-for-max7315.patch

