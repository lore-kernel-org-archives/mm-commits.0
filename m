From: akpm@linux-foundation.org
Subject: [merged] cpumask-fix-code-comment.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:29 -0700
Message-ID: <57a23449.A90LS2bLWhk214i9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbcHCSNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: fix code comment
has been removed from the -mm tree.  Its filename was
     cpumask-fix-code-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: cpumask: fix code comment

Fix code comment for cpumask_parse().

Link: http://lkml.kernel.org/r/71aae2c60ae5dae0cf554199ce6aea8f88c69347.1465380581.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/cpumask.h~cpumask-fix-code-comment include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-fix-code-comment
+++ a/include/linux/cpumask.h
@@ -579,7 +579,7 @@ static inline int cpumask_parselist_user
 }
 
 /**
- * cpumask_parse - extract a cpumask from from a string
+ * cpumask_parse - extract a cpumask from a string
  * @buf: the buffer to extract from
  * @dstp: the cpumask to set.
  *
_

Patches currently in -mm which might be from geliangtang@gmail.com are


