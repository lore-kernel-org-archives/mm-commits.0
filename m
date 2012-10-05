From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-isl1208c-add-support-for-the-isl1218.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:28 -0700
Message-ID: <20121005201628.BB941100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62099 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2JEUQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:29 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235203ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gardner.ben@gmail.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: add support for the ISL1218
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-isl1208c-add-support-for-the-isl1218.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

