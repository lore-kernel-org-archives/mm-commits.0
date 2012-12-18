From: akpm@linux-foundation.org
Subject: [merged] rtc-imxdi-support-for-imx53.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:37 -0800
Message-ID: <20121218200738.1F3BE200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:56171 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2LRUHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:41 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so69622lbc.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stigge@antcom.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-imxdi: support for i.MX53
has been removed from the -mm tree.  Its filename was
     rtc-imxdi-support-for-imx53.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roland Stigge <stigge@antcom.de>
Subject: drivers/rtc/rtc-imxdi: support for i.MX53

Enable support for i.MX53 in addition to i.MX25 by enabling the driver on
ARCH_MXC generally.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-imxdi-support-for-imx53 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-imxdi-support-for-imx53
+++ a/drivers/rtc/Kconfig
@@ -768,7 +768,7 @@ config RTC_DRV_DAVINCI
 
 config RTC_DRV_IMXDI
 	tristate "Freescale IMX DryIce Real Time Clock"
-	depends on SOC_IMX25
+	depends on ARCH_MXC
 	help
 	   Support for Freescale IMX DryIce RTC
 
_

Patches currently in -mm which might be from stigge@antcom.de are

origin.patch
linux-next.patch

