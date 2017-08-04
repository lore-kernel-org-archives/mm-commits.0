From: akpm@linux-foundation.org
Subject: [merged] kthread-fix-documentation-build-warning.patch
 removed from -mm tree
Date: Fri, 04 Aug 2017 14:18:28 -0700
Message-ID: <20170804211828.mgJQK6DH7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752258AbdHDVS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 17:18:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: kthread: fix documentation build warning
has been removed from the -mm tree.  Its filename was
     kthread-fix-documentation-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jonathan Corbet <corbet@lwn.net>
Subject: kthread: fix documentation build warning

The kerneldoc comment for kthread_create() had an incorrect argument name,
leading to a warning in the docs build.  Correct it, and make one more
small step toward a warning-free build.

Link: http://lkml.kernel.org/r/20170724135916.7f486c6f@lwn.net
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kthread.h~kthread-fix-documentation-build-warning include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-fix-documentation-build-warning
+++ a/include/linux/kthread.h
@@ -15,7 +15,7 @@ struct task_struct *kthread_create_on_no
  * @threadfn: the function to run in the thread
  * @data: data pointer for @threadfn()
  * @namefmt: printf-style format string for the thread name
- * @...: arguments for @namefmt.
+ * @arg...: arguments for @namefmt.
  *
  * This macro will create a kthread on the current node, leaving it in
  * the stopped state.  This is just a helper for kthread_create_on_node();
_

Patches currently in -mm which might be from corbet@lwn.net are


