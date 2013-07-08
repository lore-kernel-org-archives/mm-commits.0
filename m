From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1216c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:44 -0700
Message-ID: <51db1418.qRqeeQFV3m3787uf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3GHTdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tsbogend@alpha.franken.de, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-ds1216c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,tsbogend@alpha.franken.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:44 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1216.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1216c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1216.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1216.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1216.c~drivers-rtc-rtc-ds1216c-remove-empty-function drivers/rtc/rtc-ds1216.c
--- a/drivers/rtc/rtc-ds1216.c~drivers-rtc-rtc-ds1216c-remove-empty-function
+++ a/drivers/rtc/rtc-ds1216.c
@@ -167,17 +167,11 @@ static int __init ds1216_rtc_probe(struc
 	return 0;
 }
 
-static int __exit ds1216_rtc_remove(struct platform_device *pdev)
-{
-	return 0;
-}
