From: akpm@linux-foundation.org
Subject: + applesmc-sensors-set-for-macbook2-try-2.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:30:35 -0800
Message-ID: <200712052230.lB5MUZwG028361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbXLEWbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:31:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rkoktarianto@gmail.com, mhoffman@lightlink.com, nicolas@boichat.ch


The patch titled
     applesmc: sensors set for MacBook2
has been added to the -mm tree.  Its filename is
     applesmc-sensors-set-for-macbook2-try-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: applesmc: sensors set for MacBook2
From: Riki Oktarianto <rkoktarianto@gmail.com>

Add sensors set for MacBook2, from register dump on a mid-2007 MacBook2.

Signed-off-by: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-sensors-set-for-macbook2-try-2 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-sensors-set-for-macbook2-try-2
+++ a/drivers/hwmon/applesmc.c
@@ -85,8 +85,8 @@ static const char* temperature_sensors_s
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
 /* Set 1: Macbook2 set */
-	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
-	  "Th1H", NULL },
+	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "TTF0", "Th0H",
+	  "Th0S", "Th1H", NULL },
 /* Set 2: Macbook set */
 	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
 	  "Th1H", "Ts0P", NULL },
_

Patches currently in -mm which might be from rkoktarianto@gmail.com are

applesmc-sensors-set-for-macbook2.patch
applesmc-sensors-set-for-macbook2-try-2.patch
