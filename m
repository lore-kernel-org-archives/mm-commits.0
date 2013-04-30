From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-add-missing-module-author-name.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:14 -0700
Message-ID: <20130430185414.706D831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64271 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3D3SyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:15 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86451ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: add missing module author name
has been removed from the -mm tree.  Its filename was
     rtc-max77686-add-missing-module-author-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

