From: akpm@linux-foundation.org
Subject: - raid-remove-trailing-space-from-printk-line.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:38 -0700
Message-ID: <200804261642.m3QGgcOW031211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757889AbYDZQnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick@nick-andrew.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     raid: remove trailing space from printk line
has been removed from the -mm tree.  Its filename was
     raid-remove-trailing-space-from-printk-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: raid: remove trailing space from printk line
From: Nick Andrew <nick@nick-andrew.net>

drivers/md/*.[ch] contains only one more printk line with a trailing space. 
Remove it.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~raid-remove-trailing-space-from-printk-line drivers/md/md.c
--- a/drivers/md/md.c~raid-remove-trailing-space-from-printk-line
+++ a/drivers/md/md.c
@@ -4152,7 +4152,7 @@ static int hot_remove_disk(mddev_t * mdd
 
 	return 0;
 busy:
-	printk(KERN_WARNING "md: cannot remove active disk %s from %s ... \n",
+	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
 		bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
 }
_

Patches currently in -mm which might be from nick@nick-andrew.net are

origin.patch
raid-remove-leading-tab-on-printk-messages.patch

