From: akpm@linux-foundation.org
Subject: + writeback-fix-a-typo-in-comment.patch added to -mm tree
Date: Tue, 27 Nov 2012 14:57:44 -0800
Message-ID: <20121127225744.9CC95100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49914 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2K0W5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 17:57:45 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so418468ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 14:57:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com


The patch titled
     Subject: writeback: fix a typo in comment
has been added to the -mm tree.  Its filename is
     writeback-fix-a-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yan Hong <clouds.yan@gmail.com>
Subject: writeback: fix a typo in comment

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-fix-a-typo-in-comment fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-a-typo-in-comment
+++ a/fs/fs-writeback.c
@@ -1034,7 +1034,7 @@ int bdi_writeback_thread(void *data)
 	while (!kthread_freezable_should_stop(NULL)) {
 		/*
 		 * Remove own delayed wake-up timer, since we are already awake
-		 * and we'll take care of the preriodic write-back.
+		 * and we'll take care of the periodic write-back.
 		 */
 		del_timer(&wb->wakeup_timer);
 
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

linux-next.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
writeback-fix-a-typo-in-comment.patch

