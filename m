From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:24 -0800
Message-ID: <54dbb9c4.rK4LeNx60w9p2YVE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbBKUVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unreachable code in __ocfs2_recovery_thread()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: remove unreachable code in __ocfs2_recovery_thread()

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/journal.c~ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread
+++ a/fs/ocfs2/journal.c
@@ -1447,7 +1447,6 @@ bail:
 	 * requires that we call do_exit().  And it isn't exported, but
 	 * complete_and_exit() seems to be a minimal wrapper around it. */
 	complete_and_exit(NULL, status);
-	return status;
 }
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch
mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch
linux-next.patch

