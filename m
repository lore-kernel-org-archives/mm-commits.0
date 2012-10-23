From: akpm@linux-foundation.org
Subject: + rtc-imxdi-support-for-imx53.patch added to -mm tree
Date: Tue, 23 Oct 2012 11:59:47 -0700
Message-ID: <20121023185948.243B4100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44967 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab2JWS7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 14:59:49 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so522304vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 11:59:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stigge@antcom.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk


The patch titled
     Subject: drivers/rtc/rtc-imxdi: support for i.MX53
has been added to the -mm tree.  Its filename is
     rtc-imxdi-support-for-imx53.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
rtc-imxdi-support-for-imx53.patch
rtc-imxdi-add-devicetree-support.patch
arm-mach-imx-support-for-dryice-rtc-in-imx53.patch

