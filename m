From: akpm@linux-foundation.org
Subject: + ocfs2-improve-recovery-performance-v2.patch added to -mm tree
Date: Fri, 08 Jul 2016 14:45:29 -0700
Message-ID: <57801ef9.+vFOYw/0btEnGO+y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcGHVpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-improve-recovery-performance-v2
has been added to the -mm tree.  Its filename is
     ocfs2-improve-recovery-performance-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-improve-recovery-performance-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-improve-recovery-performance-v2.patch

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
Subject: ocfs2-improve-recovery-performance-v2

Link: http://lkml.kernel.org/r/1467858288-4159-1-git-send-email-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: "Gang He" <ghe@suse.com>
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
ocfs2-improve-recovery-performance-v2.patch

