From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-m41t93c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:34:02 -0700
Message-ID: <51db142a.j66bK1aucJfBrVYv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GHTeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n.voss@weinmann.de, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-m41t93c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,n.voss@weinmann.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:02 -0700


The patch titled
     Subject: drivers/rtc/rtc-m41t93.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-m41t93c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-m41t93.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Nikolaus Voss <n.voss@weinmann.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t93.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/rtc/rtc-m41t93.c~drivers-rtc-rtc-m41t93c-remove-empty-function drivers/rtc/rtc-m41t93.c
--- a/drivers/rtc/rtc-m41t93.c~drivers-rtc-rtc-m41t93c-remove-empty-function
+++ a/drivers/rtc/rtc-m41t93.c
@@ -194,19 +194,12 @@ static int m41t93_probe(struct spi_devic
 	return 0;
 }
 
-
-static int m41t93_remove(struct spi_device *spi)
-{
-	return 0;
-}
