From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps80031c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:34:44 -0700
Message-ID: <51db1454.ODYIgSGNDW3f0AWy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3GHTev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ldewangan@nvidia.com, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-tps80031c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,ldewangan@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:44 -0700


The patch titled
     Subject: drivers/rtc/rtc-tps80031.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps80031c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-tps80031.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps80031.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-tps80031.c~drivers-rtc-rtc-tps80031c-remove-empty-function drivers/rtc/rtc-tps80031.c
--- a/drivers/rtc/rtc-tps80031.c~drivers-rtc-rtc-tps80031c-remove-empty-function
+++ a/drivers/rtc/rtc-tps80031.c
@@ -298,11 +298,6 @@ static int tps80031_rtc_probe(struct pla
 	return 0;
 }
 
-static int tps80031_rtc_remove(struct platform_device *pdev)
-{
-	return 0;
-}
