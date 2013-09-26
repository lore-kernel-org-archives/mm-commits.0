From: akpm@linux-foundation.org
Subject: +
 drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch added to -mm tree
Date: Wed, 25 Sep 2013 17:08:07 -0700
Message-ID: <52437ae7.pMIrlICp0omJK9MM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3IZAII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 20:08:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 17:08:07 -0700


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: remove redundant spi_set_drvdata
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/backlight/l4f00242t03.c: remove redundant spi_set_drvdata

Driver core sets driver data to NULL upon failure or remove.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -244,7 +244,6 @@ static int l4f00242t03_remove(struct spi
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
-	spi_set_drvdata(spi, NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch
drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
linux-next.patch

