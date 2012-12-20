From: akpm@linux-foundation.org
Subject: + drivers-rtc-remove-unnecessary-semicolons.patch added to -mm tree
Date: Thu, 20 Dec 2012 15:49:00 -0800
Message-ID: <20121220234900.8EB19820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:37542 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LTXtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 18:49:02 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so115744ghb.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 15:49:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.senna@gmail.com


The patch titled
     Subject: drivers/rtc: remove unnecessary semicolons
has been added to the -mm tree.  Its filename is
     drivers-rtc-remove-unnecessary-semicolons.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: drivers/rtc: remove unnecessary semicolons

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |    2 +-
 drivers/rtc/rtc-pcf8563.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-isl12022.c~drivers-rtc-remove-unnecessary-semicolons drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~drivers-rtc-remove-unnecessary-semicolons
+++ a/drivers/rtc/rtc-isl12022.c
@@ -227,7 +227,7 @@ static int isl12022_set_datetime(struct 
 					 buf[ISL12022_REG_SC + i]);
 		if (ret)
 			return -EIO;
-	};
+	}
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-remove-unnecessary-semicolons drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-remove-unnecessary-semicolons
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -181,7 +181,7 @@ static int pcf8563_set_datetime(struct i
 				__func__, err, data[0], data[1]);
 			return -EIO;
 		}
-	};
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from peter.senna@gmail.com are

origin.patch
linux-next.patch
drivers-rtc-remove-unnecessary-semicolons.patch

