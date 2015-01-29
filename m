From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch
 added to -mm tree
Date: Thu, 29 Jan 2015 13:57:39 -0800
Message-ID: <54caacd3.vYTcOUYm11R48lk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbbA2V5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:57:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unreachable code in __ocfs2_recovery_thread()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-remove-unreachable-code.patch
ocfs2-removes-mlog_errno-call-twice-in-ocfs2_find_dir_space_el.patch
ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch
linux-next.patch

