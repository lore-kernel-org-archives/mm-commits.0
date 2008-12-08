From: akpm@linux-foundation.org
Subject: + drivers-serial-s3c2440c-fix-typo-in-module_license.patch added to -mm tree
Date: Mon, 08 Dec 2008 14:56:42 -0800
Message-ID: <200812082256.mB8MugNc022462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbYLHW5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 17:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@gmail.com, ben-linux@fluff.org


The patch titled
     drivers/serial/s3c2440.c: fix typo in MODULE_LICENSE
has been added to the -mm tree.  Its filename is
     drivers-serial-s3c2440c-fix-typo-in-module_license.patch

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
Subject: drivers/serial/s3c2440.c: fix typo in MODULE_LICENSE
From: Balaji Rao <balajirrao@gmail.com>

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
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

drivers-serial-s3c2440c-fix-typo-in-module_license.patch

