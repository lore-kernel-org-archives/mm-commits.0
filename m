From: akpm@linux-foundation.org
Subject: + raid-remove-trailing-space-from-printk-line.patch added to -mm tree
Date: Tue, 15 Apr 2008 00:40:39 -0700
Message-ID: <200804150740.m3F7edar017385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759546AbYDOHlB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 03:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick@nick-andrew.net, neilb@suse.de


The patch titled
     raid: remove trailing space from printk line
has been added to the -mm tree.  Its filename is
     raid-remove-trailing-space-from-printk-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kconfig-cleanup-block-kconfig-help-descriptions.patch
kconfig-cleanup-block-kconfigiosched-help-descriptions.patch
raid-remove-leading-tab-on-printk-messages.patch
raid-remove-trailing-space-from-printk-line.patch

