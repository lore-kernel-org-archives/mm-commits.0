From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cleanup-unused-func-declaration-and-assignment.patch removed from -mm
 tree
Date: Thu, 16 Nov 2017 11:58:50 -0800
Message-ID: <20171116195850.y7PO0BNTr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758436AbdKPT6v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 14:58:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: cleanup unused func declaration and assignment
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-unused-func-declaration-and-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: cleanup unused func declaration and assignment

Link: http://lkml.kernel.org/r/59E064BB.8000005@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c             |    2 --
 fs/ocfs2/cluster/heartbeat.h |    2 --
 2 files changed, 4 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-cleanup-unused-func-declaration-and-assignment fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-cleanup-unused-func-declaration-and-assignment
+++ a/fs/ocfs2/alloc.c
@@ -3585,8 +3585,6 @@ static int ocfs2_merge_rec_left(struct o
 		 * The easy case - we can just plop the record right in.
 		 */
 		*left_rec = *split_rec;
