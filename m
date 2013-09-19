From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 15:10:16 -0700
Message-ID: <523b7648.gJqA92o2vVZ/M/p+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3ISWKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:16 -0700


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: remove redundant dev_set_drvdata
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-cmos.c: remove redundant dev_set_drvdata

Driver core sets the driver data to NULL upon device_release or on probe
failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata
+++ a/drivers/rtc/rtc-cmos.c
@@ -789,7 +789,6 @@ static void __exit cmos_do_remove(struct
 	cmos->iomem = NULL;
 
 	cmos->dev = NULL;
-	dev_set_drvdata(dev, NULL);
 }
 
 #ifdef	CONFIG_PM
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
linux-next.patch

