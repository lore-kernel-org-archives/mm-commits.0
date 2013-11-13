From: akpm@linux-foundation.org
Subject: [merged] fs-ocfs2-filec-fix-wrong-comment.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:37:10 -0800
Message-ID: <5283e2f6.U+Ld1Qm4zVLLbq+e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3KMUhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, junxiao.bi@oracle.com

Subject: [merged] fs-ocfs2-filec-fix-wrong-comment.patch removed from -mm tree
To: junxiao.bi@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:10 -0800


The patch titled
     Subject: fs/ocfs2/file.c: fix wrong comment
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-filec-fix-wrong-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: fs/ocfs2/file.c: fix wrong comment

Unwritten extent only exists for file systems which support holes.  But
the comment said was opposite meaning and also the comment is not very
clear, so rephase it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~fs-ocfs2-filec-fix-wrong-comment fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~fs-ocfs2-filec-fix-wrong-comment
+++ a/fs/ocfs2/file.c
@@ -580,7 +580,7 @@ static int __ocfs2_extend_allocation(str
 	int did_quota = 0;
 
 	/*
-	 * This function only exists for file systems which don't
+	 * Unwritten extent only exists for file systems which
 	 * support holes.
 	 */
 	BUG_ON(mark_unwritten && !ocfs2_sparse_alloc(osb));
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

origin.patch
configfs-fix-race-between-dentry-put-and-lookup.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch

