From: akpm@linux-foundation.org
Subject: [merged] drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch removed from -mm tree
Date: Thu, 10 Feb 2011 12:16:10 -0800
Message-ID: <201102102016.p1AKGA1x016271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756879Ab1BJUQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Feb 2011 15:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tdent48227@gmail.com, axboe@kernel.dk, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/aoe/Makefile: replace the use of <module>-objs with <module>-y
has been removed from the -mm tree.  Its filename was
     drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/aoe/Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Change Makefile to use <modules>-y instead of <modules>-objs because -objs
is deprecated and should now be switched.  According to
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/Makefile~drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y drivers/block/aoe/Makefile
--- a/drivers/block/aoe/Makefile~drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/block/aoe/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-$(CONFIG_ATA_OVER_ETH)	+= aoe.o
-aoe-objs := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
+aoe-y := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

origin.patch
kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile.patch

