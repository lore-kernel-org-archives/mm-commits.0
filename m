From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-jz4740c-make-jz4740_rtc_driver-static.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:35 -0800
Message-ID: <20120111213235.979FF100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2AKVcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:36 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, a.zummo@towertech.it, lars@metafoo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-jz4740.c: make jz4740_rtc_driver static
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-jz4740c-make-jz4740_rtc_driver-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

