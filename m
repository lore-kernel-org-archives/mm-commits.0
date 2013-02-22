From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-remove-unnecessary-semicolons.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:29 -0800
Message-ID: <20130222204329.99B7131C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:63525 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169Ab3BVUna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:30 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so103232ves.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.senna@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc: remove unnecessary semicolons
has been removed from the -mm tree.  Its filename was
     drivers-rtc-remove-unnecessary-semicolons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch

