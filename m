From: akpm@linux-foundation.org
Subject: - rtc-pcf8563-add-chip-id.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:01 -0700
Message-ID: <200807141935.m6EJZ1eR023858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535AbYGNTfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jonsmirl@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf8563: add chip id
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-add-chip-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-pcf8563: add chip id
From: Jon Smirl <jonsmirl@gmail.com>

Add the rtc8564 chip entry

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-add-chip-id drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-add-chip-id
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -302,6 +302,7 @@ static int pcf8563_remove(struct i2c_cli
 
 static const struct i2c_device_id pcf8563_id[] = {
 	{ "pcf8563", 0 },
+	{ "rtc8564", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pcf8563_id);
_

Patches currently in -mm which might be from jonsmirl@gmail.com are

linux-next.patch

