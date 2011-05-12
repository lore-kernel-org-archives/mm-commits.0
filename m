From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lm3530c-add-module_device_table.patch added to -mm tree
Date: Thu, 12 May 2011 12:43:03 -0700
Message-ID: <201105121943.p4CJh3Ih029254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab1ELTnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 15:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com


The patch titled
     drivers/leds/leds-lm3530.c: add MODULE_DEVICE_TABLE
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lm3530c-add-module_device_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-leds-leds-lm3530c-add-module_device_table.patch
linux-next.patch

