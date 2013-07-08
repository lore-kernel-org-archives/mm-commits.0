From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-rv3029c2c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:34:30 -0700
Message-ID: <51db1446.W7JMunj77gF7n9fa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GHTea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregory.hermant@calao-systems.com, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-rv3029c2c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,gregory.hermant@calao-systems.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:30 -0700


The patch titled
     Subject: drivers/rtc/rtc-rv3029c2.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-rv3029c2c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-rv3029c2.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Gregory Hermant <gregory.hermant@calao-systems.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rv3029c2.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-rv3029c2.c~drivers-rtc-rtc-rv3029c2c-remove-empty-function drivers/rtc/rtc-rv3029c2.c
--- a/drivers/rtc/rtc-rv3029c2.c~drivers-rtc-rtc-rv3029c2c-remove-empty-function
+++ a/drivers/rtc/rtc-rv3029c2.c
@@ -412,17 +412,11 @@ static int rv3029c2_probe(struct i2c_cli
 	return 0;
 }
 
-static int rv3029c2_remove(struct i2c_client *client)
-{
-	return 0;
-}
