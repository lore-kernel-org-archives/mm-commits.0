From: akpm@linux-foundation.org
Subject: - drivers-serial-s3c2440c-fix-typo-in-module_license.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:29:03 -0800
Message-ID: <200812101929.mBAJT3rI021576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246AbYLJTaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@gmail.com, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     drivers/serial/s3c2440.c: fix typo in MODULE_LICENSE
has been removed from the -mm tree.  Its filename was
     drivers-serial-s3c2440c-fix-typo-in-module_license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/serial/s3c2440.c: fix typo in MODULE_LICENSE
From: Balaji Rao <balajirrao@gmail.com>

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/s3c2440.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/s3c2440.c~drivers-serial-s3c2440c-fix-typo-in-module_license drivers/serial/s3c2440.c
--- a/drivers/serial/s3c2440.c~drivers-serial-s3c2440c-fix-typo-in-module_license
+++ a/drivers/serial/s3c2440.c
@@ -177,5 +177,5 @@ module_exit(s3c2440_serial_exit);
 
 MODULE_DESCRIPTION("Samsung S3C2440,S3C2442 SoC Serial port driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
-MODULE_LICENSE("GPLi v2");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:s3c2440-uart");
_

Patches currently in -mm which might be from balajirrao@gmail.com are

origin.patch

