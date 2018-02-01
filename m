From: akpm@linux-foundation.org
Subject: [patch 006/119] fs/ocfs2/dlm/dlmmaster.c: clean up dead
 code
Date: Wed, 31 Jan 2018 16:14:21 -0800
Message-ID: <20180201001421.c57ViY-wm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33522 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754277AbeBAAOX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:14:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
