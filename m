From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-snvsc-remove-redundant-of_match_ptr.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:44:22 -0800
Message-ID: <5283e4a6.QNLkrcThozRGmLvk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3KMUoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:44:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-snvsc-remove-redundant-of_match_ptr.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:44:22 -0800


The patch titled
     Subject: drivers/rtc/rtc-snvs.c: remove redundant of_match_ptr
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-snvsc-remove-redundant-of_match_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-snvs.c: remove redundant of_match_ptr

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-snvs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-snvs.c~drivers-rtc-rtc-snvsc-remove-redundant-of_match_ptr drivers/rtc/rtc-snvs.c
--- a/drivers/rtc/rtc-snvs.c~drivers-rtc-rtc-snvsc-remove-redundant-of_match_ptr
+++ a/drivers/rtc/rtc-snvs.c
@@ -329,7 +329,7 @@ static struct platform_driver snvs_rtc_d
 		.name	= "snvs_rtc",
 		.owner	= THIS_MODULE,
 		.pm	= &snvs_rtc_pm_ops,
-		.of_match_table = of_match_ptr(snvs_dt_ids),
+		.of_match_table = snvs_dt_ids,
 	},
 	.probe		= snvs_rtc_probe,
 };
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

