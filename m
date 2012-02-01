From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pm8xxxc-make-pm8xxx_rtc_pm_ops-static.patch added to -mm tree
Date: Wed, 01 Feb 2012 15:37:11 -0800
Message-ID: <20120201233711.A1039A03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:40348 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2BAXhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 18:37:12 -0500
Received: by ghrr17 with SMTP id r17so195770ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 15:37:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zicrim@gmail.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-pm8xxx.c: make pm8xxx_rtc_pm_ops static
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pm8xxxc-make-pm8xxx_rtc_pm_ops-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Navin P <zicrim@gmail.com>
Subject: drivers/rtc/rtc-pm8xxx.c: make pm8xxx_rtc_pm_ops static

Signed-off-by: Navin P <zicrim@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~drivers-rtc-rtc-pm8xxxc-make-pm8xxx_rtc_pm_ops-static drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~drivers-rtc-rtc-pm8xxxc-make-pm8xxx_rtc_pm_ops-static
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -520,7 +520,7 @@ static int pm8xxx_rtc_suspend(struct dev
 }
 #endif
 
-SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops, pm8xxx_rtc_suspend, pm8xxx_rtc_resume);
+static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops, pm8xxx_rtc_suspend, pm8xxx_rtc_resume);
 
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
_
Subject: Subject: drivers/rtc/rtc-pm8xxx.c: make pm8xxx_rtc_pm_ops static

Patches currently in -mm which might be from zicrim@gmail.com are

drivers-rtc-rtc-pm8xxxc-make-pm8xxx_rtc_pm_ops-static.patch

