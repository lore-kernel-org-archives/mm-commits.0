From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-improve-recovery-performance-v2.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 14:47:39 -0700
Message-ID: <5797da7b.yDz+gSGd9r+peddt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbcGZVrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-improve-recovery-performance-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-improve-recovery-performance-v2.patch

This patch was dropped because it was folded into ocfs2-improve-recovery-performance.patch

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2-improve-recovery-performance-v2

Link: http://lkml.kernel.org/r/1467858288-4159-1-git-send-email-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2 fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2
+++ a/fs/ocfs2/journal.c
@@ -1194,6 +1194,7 @@ static int ocfs2_force_read_journal(stru
 
 			brelse(bh);
 			bh = NULL;
+			p_blkno++;
 		}
 
 		v_blkno += p_blocks;
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-improve-recovery-performance.patch

