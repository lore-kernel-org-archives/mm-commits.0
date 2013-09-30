From: akpm@linux-foundation.org
Subject: [merged]
 drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch removed from -mm tree
Date: Mon, 30 Sep 2013 11:57:36 -0700
Message-ID: <5249c9a0.RelpUCyZUI69DRqB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab3I3S5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 14:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: [merged] drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch removed from -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 11:57:36 -0700


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: remove redundant spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
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

