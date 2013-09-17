From: akpm@linux-foundation.org
Subject: + fs-ocfs2-filec-fix-wrong-comment.patch added to -mm tree
Date: Tue, 17 Sep 2013 14:53:30 -0700
Message-ID: <5238cf5a.AwoXZyLimlLcdwPV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3IQVxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 17:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, junxiao.bi@oracle.com

Subject: + fs-ocfs2-filec-fix-wrong-comment.patch added to -mm tree
To: junxiao.bi@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 14:53:30 -0700


The patch titled
     Subject: fs/ocfs2/file.c: fix wrong comment
has been added to the -mm tree.  Its filename is
     fs-ocfs2-filec-fix-wrong-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-filec-fix-wrong-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-filec-fix-wrong-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ocfs2-filec-fix-wrong-comment.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
linux-next.patch

