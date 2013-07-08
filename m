From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1286c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:46 -0700
Message-ID: <51db141a.8ro1GC0DHtStxSZ5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3GHTdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tsbogend@alpha.franken.de, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-ds1286c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,tsbogend@alpha.franken.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:46 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1286.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1286c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1286.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1286.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1286.c~drivers-rtc-rtc-ds1286c-remove-empty-function drivers/rtc/rtc-ds1286.c
--- a/drivers/rtc/rtc-ds1286.c~drivers-rtc-rtc-ds1286c-remove-empty-function
+++ a/drivers/rtc/rtc-ds1286.c
@@ -353,18 +353,12 @@ static int ds1286_probe(struct platform_
 	return 0;
 }
 
-static int ds1286_remove(struct platform_device *pdev)
-{
-	return 0;
-}
