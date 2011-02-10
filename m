From: akpm@linux-foundation.org
Subject: [merged] drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch removed from -mm tree
Date: Thu, 10 Feb 2011 12:16:08 -0800
Message-ID: <201102102016.p1AKG8Vn016267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756877Ab1BJUQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Feb 2011 15:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tdent48227@gmail.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/block/Makefile: replace the use of <module>-objs with <module>-y
has been removed from the -mm tree.  Its filename was
     drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Change Makefile to use <modules>-y instead of <modules>-objs because -objs
is deprecated and should now be switched.  According to
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/Makefile~drivers-block-makefile-replace-the-use-of-module-objs-with-module-y drivers/block/Makefile
--- a/drivers/block/Makefile~drivers-block-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/block/Makefile
@@ -39,4 +39,4 @@ obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 
-swim_mod-objs	:= swim.o swim_asm.o
+swim_mod-y	:= swim.o swim_asm.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

origin.patch
kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile.patch

