From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pm8xxxc-make-pm8xxx_rtc_pm_ops-static.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:37 -0700
Message-ID: <20120326193137.528ABA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:54545 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab2CZTbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2012 15:31:39 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so288307laa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zicrim@gmail.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pm8xxx.c: make pm8xxx_rtc_pm_ops static
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pm8xxxc-make-pm8xxx_rtc_pm_ops-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from zicrim@gmail.com are

origin.patch

