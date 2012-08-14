From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl1208c-add-support-for-the-isl1218.patch added to -mm tree
Date: Tue, 14 Aug 2012 15:46:35 -0700
Message-ID: <20120814224636.221E120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:63036 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2HNWqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 18:46:38 -0400
Received: by fadw1 with SMTP id w1so44516fad.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 15:46:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gardner.ben@gmail.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: add support for the ISL1218
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl1208c-add-support-for-the-isl1218.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ben Gardner <gardner.ben@gmail.com>
Subject: drivers/rtc/rtc-isl1208.c: add support for the ISL1218

The ISL1218 chip is identical to the ISL1208, except that it has 6
additional user-storage registers.  This patch does not enable access to
those additional registers, but only adds the chip name to the list.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-add-support-for-the-isl1218 drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-add-support-for-the-isl1218
+++ a/drivers/rtc/rtc-isl1208.c
@@ -697,6 +697,7 @@ isl1208_remove(struct i2c_client *client
 
 static const struct i2c_device_id isl1208_id[] = {
 	{ "isl1208", 0 },
+	{ "isl1218", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, isl1208_id);
_

Patches currently in -mm which might be from gardner.ben@gmail.com are

drivers-rtc-rtc-isl1208c-add-support-for-the-isl1218.patch

