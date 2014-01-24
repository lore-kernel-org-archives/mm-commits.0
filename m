From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-hym8563c-remove-redundant-of_match_ptr-helper.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:56 -0800
Message-ID: <52e2b8e0.K0Jrm/0Po1jCTYMW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaAXTC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-hym8563c-remove-redundant-of_match_ptr-helper.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:56 -0800


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: remove redundant of_match_ptr() helper
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-hym8563c-remove-redundant-of_match_ptr-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-hym8563.c: remove redundant of_match_ptr() helper

'hym8563_dt_idtable' is always compiled in.  Hence the helper macro is not
needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-remove-redundant-of_match_ptr-helper drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-remove-redundant-of_match_ptr-helper
+++ a/drivers/rtc/rtc-hym8563.c
@@ -593,7 +593,7 @@ static struct i2c_driver hym8563_driver
 		.name	= "rtc-hym8563",
 		.owner	= THIS_MODULE,
 		.pm	= &hym8563_pm_ops,
-		.of_match_table	= of_match_ptr(hym8563_dt_idtable),
+		.of_match_table	= hym8563_dt_idtable,
 	},
 	.probe		= hym8563_probe,
 	.id_table	= hym8563_id,
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
linux-next.patch

