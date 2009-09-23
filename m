From: akpm@linux-foundation.org
Subject: [folded] pc-fs-char_devc-remove-useless-loop-fix.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:47:16 -0700
Message-ID: <200909232247.n8NMlHBH020113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbZIWWrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:47:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, renzo@cs.unibo.it, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pc-fs-char_devc-remove-useless-loop-fix
has been removed from the -mm tree.  Its filename was
     pc-fs-char_devc-remove-useless-loop-fix.patch

This patch was dropped because it was folded into fs-char_devc-remove-useless-loop.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pc-fs-char_devc-remove-useless-loop-fix
From: Dave Young <hidave.darkstar@gmail.com>

Fix build warning about the unused variable in char_dev.c:267

Remove the unused char *s.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Renzo Davoli <renzo@cs.unibo.it>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/char_dev.c~pc-fs-char_devc-remove-useless-loop-fix fs/char_dev.c
--- a/fs/char_dev.c~pc-fs-char_devc-remove-useless-loop-fix
+++ a/fs/char_dev.c
@@ -264,7 +264,6 @@ int __register_chrdev(unsigned int major
 {
 	struct char_device_struct *cd;
 	struct cdev *cdev;
-	char *s;
 	int err = -ENOMEM;
 
 	cd = __register_chrdev_region(major, baseminor, count, name);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
fs-char_devc-remove-useless-loop.patch
pc-fs-char_devc-remove-useless-loop-fix.patch

