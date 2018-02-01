From: akpm@linux-foundation.org
Subject: [merged] ocfs2-dlm-clean-dead-code-up.patch removed from
 -mm tree
Date: Thu, 01 Feb 2018 11:29:03 -0800
Message-ID: <20180201192903.15gE4mC5h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753368AbeBAT3F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/dlm/dlmmaster.c: clean up dead code
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-clean-dead-code-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: fs/ocfs2/dlm/dlmmaster.c: clean up dead code

This code has been commented out for 12 years.  Remove it.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373CED7EF9E@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-clean-dead-code-up fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-clean-dead-code-up
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1122,13 +1122,6 @@ recheck:
 	/* sleep if we haven't finished voting yet */
 	if (sleep) {
 		unsigned long timeo = msecs_to_jiffies(DLM_MASTERY_TIMEOUT_MS);
