From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-jz4740c-make-jz4740_rtc_driver-static.patch added to -mm tree
Date: Tue, 20 Dec 2011 15:56:28 -0800
Message-ID: <20111220235628.9D72F10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:39627 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1LTX43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 18:56:29 -0500
Received: by ghrr15 with SMTP id r15so644077ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 15:56:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it, lars@metafoo.de


The patch titled
     Subject: drivers/rtc/rtc-jz4740.c: make jz4740_rtc_driver static
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-jz4740c-make-jz4740_rtc_driver-static.patch

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
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/rtc/rtc-jz4740.c: make jz4740_rtc_driver static

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-jz4740.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-jz4740.c~drivers-rtc-rtc-jz4740c-make-jz4740_rtc_driver-static drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~drivers-rtc-rtc-jz4740c-make-jz4740_rtc_driver-static
+++ a/drivers/rtc/rtc-jz4740.c
@@ -345,7 +345,7 @@ static const struct dev_pm_ops jz4740_pm
 #define JZ4740_RTC_PM_OPS NULL
 #endif  /* CONFIG_PM */
 
-struct platform_driver jz4740_rtc_driver = {
+static struct platform_driver jz4740_rtc_driver = {
 	.probe	 = jz4740_rtc_probe,
 	.remove	 = __devexit_p(jz4740_rtc_remove),
 	.driver	 = {
_
Subject: Subject: drivers/rtc/rtc-jz4740.c: make jz4740_rtc_driver static

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch
leds-bd2802-use-gpio_request_one.patch
leds-netxbig-use-gpio_request_one.patch
drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch
rtc-convert-drivers-rtc-to-use-module_platform_driver.patch
drivers-rtc-rtc-mc13xxxc-make-mc13xxx_rtc_idtable-static.patch
drivers-rtc-rtc-jz4740c-make-jz4740_rtc_driver-static.patch

