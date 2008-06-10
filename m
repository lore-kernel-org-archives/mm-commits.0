From: akpm@linux-foundation.org
Subject: - cciss-bump-version-to-20-to-reflect-new-hw-support.patch removed from -mm tree
Date: Tue, 10 Jun 2008 13:51:10 -0700
Message-ID: <200806102051.m5AKpAN2028716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758486AbYFJUvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 16:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cciss: bump version to .20 to reflect new HW support
has been removed from the -mm tree.  Its filename was
     cciss-bump-version-to-20-to-reflect-new-hw-support.patch

This patch was dropped because it was folded into cciss-add-new-hardware-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: bump version to .20 to reflect new HW support
From: Mike Miller <mike.miller@hp.com>

Bump the driver version to 3.6.20 to reflect the new hardware support from
patch 1 of this set.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/cciss.c~cciss-bump-version-to-20-to-reflect-new-hw-support drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-bump-version-to-20-to-reflect-new-hw-support
+++ a/drivers/block/cciss.c
@@ -53,16 +53,16 @@
 #include <linux/scatterlist.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
+#define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
-MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.14");
+MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
 MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
 			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m"
 			" Smart Array G2 Series SAS/SATA Controllers");
-MODULE_VERSION("3.6.14");
+MODULE_VERSION("3.6.20");
 MODULE_LICENSE("GPL");
 
 #include "cciss_cmd.h"
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-add-new-hardware-support.patch
cciss-bump-version-to-20-to-reflect-new-hw-support.patch

