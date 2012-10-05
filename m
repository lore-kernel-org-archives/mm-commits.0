From: akpm@linux-foundation.org
Subject: [merged] rtc-kconfig-fixup-dependency-for-ab8500.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:54 -0700
Message-ID: <20121005201754.AE792100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49101 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2JEURz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:55 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so237019qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ulf.hansson@linaro.org, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: kconfig: fix up dependency for ab8500
has been removed from the -mm tree.  Its filename was
     rtc-kconfig-fixup-dependency-for-ab8500.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: rtc: kconfig: fix up dependency for ab8500

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-fixup-dependency-for-ab8500 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-fixup-dependency-for-ab8500
+++ a/drivers/rtc/Kconfig
@@ -738,6 +738,7 @@ config RTC_DRV_AB3100
 config RTC_DRV_AB8500
 	tristate "ST-Ericsson AB8500 RTC"
 	depends on AB8500_CORE
+	select RTC_INTF_DEV
 	select RTC_INTF_DEV_UIE_EMUL
 	help
 	  Select this to enable the ST-Ericsson AB8500 power management IC RTC
_

Patches currently in -mm which might be from ulf.hansson@linaro.org are

origin.patch
linux-next.patch

