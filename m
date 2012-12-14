From: akpm@linux-foundation.org
Subject: [merged] writeback-fix-a-typo-in-comment.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:38 -0800
Message-ID: <20121214232939.173DA200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:48366 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2LNX3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:41 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so208208wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: fix a typo in comment
has been removed from the -mm tree.  Its filename was
     writeback-fix-a-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch

