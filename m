From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-bq32kc-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:42 -0700
Message-ID: <51db1416.5nZTaKrx2kbXELmM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3GHTdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-bq32kc-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:42 -0700


The patch titled
     Subject: drivers/rtc/rtc-bq32k.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-bq32kc-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-bq32k.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-bq32k.c~drivers-rtc-rtc-bq32kc-remove-empty-function drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~drivers-rtc-rtc-bq32kc-remove-empty-function
+++ a/drivers/rtc/rtc-bq32k.c
@@ -163,11 +163,6 @@ static int bq32k_probe(struct i2c_client
 	return 0;
 }
 
-static int bq32k_remove(struct i2c_client *client)
-{
-	return 0;
-}
