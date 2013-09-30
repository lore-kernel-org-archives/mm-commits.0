From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr.patch
 added to -mm tree
Date: Mon, 30 Sep 2013 14:50:36 -0700
Message-ID: <5249f22c.qv60FrK4PZ2E0fX8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab3I3Vuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 17:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@prisktech.co.nz, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr.patch added to -mm tree
To: sachin.kamat@linaro.org,linux@prisktech.co.nz
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 14:50:36 -0700


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: remove redundant of_match_ptr
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr.patch

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
Subject: drivers/rtc/rtc-vt8500.c: remove redundant of_match_ptr

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr
+++ a/drivers/rtc/rtc-vt8500.c
@@ -296,7 +296,7 @@ static struct platform_driver vt8500_rtc
 	.driver		= {
 		.name	= "vt8500-rtc",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(wmt_dt_ids),
+		.of_match_table = wmt_dt_ids,
 	},
 };
 
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
drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-omapc-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-sirfsocc-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-snvsc-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-stmp3xxxc-remove-redundant-of_match_ptr.patch
drivers-pps-clients-pps-gpioc-remove-redundant-of_match_ptr.patch
linux-next.patch

