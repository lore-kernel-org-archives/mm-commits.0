From: akpm@linux-foundation.org
Subject: + rtc-kconfig-fixup-dependency-for-ab8500.patch added to -mm tree
Date: Tue, 25 Sep 2012 13:50:31 -0700
Message-ID: <20120925205031.AC5B6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:65314 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2IYUuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 16:50:32 -0400
Received: by ghbz15 with SMTP id z15so966417ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 13:50:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ulf.hansson@linaro.org, linus.walleij@linaro.org


The patch titled
     Subject: rtc: kconfig: fix up dependency for ab8500
has been added to the -mm tree.  Its filename is
     rtc-kconfig-fixup-dependency-for-ab8500.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
rtc-kconfig-fixup-dependency-for-ab8500.patch

