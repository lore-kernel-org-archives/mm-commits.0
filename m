From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch added to -mm tree
Date: Wed, 08 Feb 2012 15:58:43 -0800
Message-ID: <20120208235843.B4A92A0331@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:53469 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2BHX6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 18:58:44 -0500
Received: by ghrr17 with SMTP id r17so114663ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 15:58:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, p.meerwald@bct-electronic.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-pca9633.c: remove unused 'adapter' variable
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-pca9633.c: remove unused 'adapter' variable

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Peter Meerwald <p.meerwald@bct-electronic.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9633.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/leds/leds-pca9633.c~drivers-leds-leds-pca9633c-remove-unused-adapter-variable drivers/leds/leds-pca9633.c
--- a/drivers/leds/leds-pca9633.c~drivers-leds-leds-pca9633c-remove-unused-adapter-variable
+++ a/drivers/leds/leds-pca9633.c
@@ -96,11 +96,9 @@ static int __devinit pca9633_probe(struc
 					const struct i2c_device_id *id)
 {
 	struct pca9633_led *pca9633;
-	struct i2c_adapter *adapter;
 	struct led_platform_data *pdata;
 	int i, err;
 
-	adapter = to_i2c_adapter(client->dev.parent);
 	pdata = client->dev.platform_data;
 
 	if (pdata) {
_
Subject: Subject: drivers/leds/leds-pca9633.c: remove unused 'adapter' variable

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
leds-lm3530-fix-setting-pltfm-als_vmax.patch
linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices-fix.patch
backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch
backlight-lp855x_blc-small-cleanups.patch
leds-lm3530-replace-pltfm-with-pdata.patch
drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

