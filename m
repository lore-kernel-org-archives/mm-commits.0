From: akpm@google.com
Subject: + loop-cleanup-set_status-interface-checkpatch-fixes.patch added to -mm tree
Date: Fri, 23 Sep 2011 13:58:09 -0700
Message-ID: <201109232058.p8NKwAeJ022812@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10550 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1IWU6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 16:58:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, axboe@kernel.dk, dmonakhov@openvz.org


The patch titled
     Subject: loop-cleanup-set_status-interface-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     loop-cleanup-set_status-interface-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@google.com>
Subject: loop-cleanup-set_status-interface-checkpatch-fixes

WARNING: line over 80 characters
#120: FILE: drivers/block/loop.c:1388:
+						(struct loop_info __user *) arg);

total: 0 errors, 1 warnings, 92 lines checked

./patches/loop-cleanup-set_status-interface.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/block/loop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/loop.c~loop-cleanup-set_status-interface-checkpatch-fixes drivers/block/loop.c
--- a/drivers/block/loop.c~loop-cleanup-set_status-interface-checkpatch-fixes
+++ a/drivers/block/loop.c
@@ -1385,7 +1385,7 @@ static int lo_ioctl(struct block_device 
 		err = -EPERM;
 		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
 			err = loop_set_status_old(lo,
-						(struct loop_info __user *) arg);
+					(struct loop_info __user *)arg);
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_old(lo, (struct loop_info __user *) arg);
_
Subject: Subject: loop-cleanup-set_status-interface-checkpatch-fixes

Patches currently in -mm which might be from akpm@google.com are

linux-next.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch

