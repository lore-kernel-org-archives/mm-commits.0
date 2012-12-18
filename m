From: akpm@linux-foundation.org
Subject: [obsolete] drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch removed from -mm tree
Date: Tue, 18 Dec 2012 11:37:11 -0800
Message-ID: <20121218193712.4411B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36698 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2LRThN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 14:37:13 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so120563vcq.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 11:37:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ili9320.c: add missing __devexit macros for remove
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ili9320.c: add missing __devexit macros for remove

The __devexit macros is added to remove function.  The macros moves the
remove function to devexit sections.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ili9320.c~drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove
+++ a/drivers/video/backlight/ili9320.c
@@ -260,7 +260,7 @@ int ili9320_probe_spi(struct spi_device 
 }
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
-int ili9320_remove(struct ili9320 *ili)
+int __devexit ili9320_remove(struct ili9320 *ili)
 {
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-add-of_find_backlight_by_node-function.patch
drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch
drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch
backlight-corgi_lcd-use-gpio_set_value_cansleep-to-avoid-warn_on.patch
checkpatch-extend-line-continuation-test.patch

