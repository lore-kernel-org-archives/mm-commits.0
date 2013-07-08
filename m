From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-bq4802c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:08 -0700
Message-ID: <51db13f4.eZbuKZHAQ2fOiPiT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3GHTdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-bq4802c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:08 -0700


The patch titled
     Subject: drivers/rtc/rtc-bq4802.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-bq4802c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-bq4802.c: remove empty function

After the switch to devm_ functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything. 
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq4802.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-bq4802.c~drivers-rtc-rtc-bq4802c-remove-empty-function drivers/rtc/rtc-bq4802.c
--- a/drivers/rtc/rtc-bq4802.c~drivers-rtc-rtc-bq4802c-remove-empty-function
+++ a/drivers/rtc/rtc-bq4802.c
@@ -186,11 +186,6 @@ out:
 
 }
 
-static int bq4802_remove(struct platform_device *pdev)
-{
-	return 0;
-}
