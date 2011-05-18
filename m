From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lm3530c-add-module_device_table.patch removed from -mm tree
Date: Wed, 18 May 2011 11:27:40 -0700
Message-ID: <201105181827.p4IIR8YX015166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933386Ab1ERS1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 14:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lm3530.c: add MODULE_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lm3530c-add-module_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lm3530.c: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>

Adding the necessary MODULE_DEVICE_TABLE() information allows the driver
to be automatically loaded by udev.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-module_device_table drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-module_device_table
+++ a/drivers/leds/leds-lm3530.c
@@ -349,6 +349,7 @@ static const struct i2c_device_id lm3530
 	{LM3530_NAME, 0},
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, lm3530_id);
 
 static struct i2c_driver lm3530_i2c_driver = {
 	.probe = lm3530_probe,
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

