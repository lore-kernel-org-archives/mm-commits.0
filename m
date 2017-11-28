From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-clean-dead-code-up.patch added to -mm tree
Date: Mon, 27 Nov 2017 16:26:02 -0800
Message-ID: <5a1cad1a.ivxZlp4+jyFJWx9R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753585AbdK1A0D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:26:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/dlm/dlmmaster.c: clean up dead code
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-clean-dead-code-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-clean-dead-code-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-clean-dead-code-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
