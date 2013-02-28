From: akpm@linux-foundation.org
Subject: + rtc-max77686-add-missing-module-author-name.patch added to -mm tree
Date: Thu, 28 Feb 2013 14:26:58 -0800
Message-ID: <20130228222659.413335A41FD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36760 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3B1W1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 17:27:00 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so262645vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 14:26:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: add missing module author name
has been added to the -mm tree.  Its filename is
     rtc-max77686-add-missing-module-author-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-max77686.c: add missing module author name

Add missing module author name to MODULE_AUTHOR macro.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-add-missing-module-author-name drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-add-missing-module-author-name
+++ a/drivers/rtc/rtc-max77686.c
@@ -627,5 +627,5 @@ static struct platform_driver max77686_r
 module_platform_driver(max77686_rtc_driver);
 
 MODULE_DESCRIPTION("Maxim MAX77686 RTC driver");
-MODULE_AUTHOR("<woong.byun@samsung.com>");
+MODULE_AUTHOR("Chiwoong Byun <woong.byun@samsung.com>");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-mv-add-__init-annotation.patch
rtc-rtc-davinci-add-__exit-annotation.patch
rtc-rtc-ds1302-add-__exit-annotation.patch
rtc-rtc-imxdi-add-__init-__exit-annotation.patch
rtc-rtc-nuc900-add-__init-__exit-annotation.patch
rtc-rtc-pcap-add-__init-__exit-annotation.patch
rtc-rtc-tegra-add-__init-__exit-annotation.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

