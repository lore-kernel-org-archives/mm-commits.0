From: akpm@linux-foundation.org
Subject: [merged] pid-fix-typo-in-function-description.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:03 -0700
Message-ID: <201105271957.p4RJv90e017637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757069Ab1E0UEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sisir.koppaka@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pid: fix typo in function description
has been removed from the -mm tree.  Its filename was
     pid-fix-typo-in-function-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

