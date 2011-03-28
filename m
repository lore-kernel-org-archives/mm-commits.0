From: akpm@linux-foundation.org
Subject: + pid-fix-typo-in-function-description.patch added to -mm tree
Date: Mon, 28 Mar 2011 14:46:00 -0700
Message-ID: <201103282146.p2SLk0Qo031706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab1C1Vqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 17:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sisir.koppaka@gmail.com


The patch titled
     pid: fix typo in function description
has been added to the -mm tree.  Its filename is
     pid-fix-typo-in-function-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid: fix typo in function description
From: Sisir Koppaka <sisir.koppaka@gmail.com>

finds is misspelt as finr. No functional change.

Signed-off-by: Sisir Koppaka <sisir.koppaka@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pid.h~pid-fix-typo-in-function-description include/linux/pid.h
--- a/include/linux/pid.h~pid-fix-typo-in-function-description
+++ a/include/linux/pid.h
@@ -105,7 +105,7 @@ extern struct pid_namespace init_pid_ns;
  * or rcu_read_lock() held.
  *
  * find_pid_ns() finds the pid in the namespace specified
- * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
+ * find_vpid() finds the pid by its virtual id, i.e. in the current namespace
  *
  * see also find_task_by_vpid() set in include/linux/sched.h
  */
_

Patches currently in -mm which might be from sisir.koppaka@gmail.com are

pid-fix-typo-in-function-description.patch

