From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-add-chip-id.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:57:14 -0700
Message-ID: <200807120057.m6C0vE4b013370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYGLA5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jonsmirl@gmail.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-pcf8563: add chip id
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-add-chip-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-pcf8563-add-chip-id.patch
linux-next.patch

