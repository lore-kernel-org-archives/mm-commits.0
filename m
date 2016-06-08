From: akpm@linux-foundation.org
Subject: + cpumask-fix-code-comment.patch added to -mm tree
Date: Wed, 08 Jun 2016 13:22:06 -0700
Message-ID: <57587e6e.QWb1AEgkb1AStkw2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbcFHUWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 16:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: fix code comment
has been added to the -mm tree.  Its filename is
     cpumask-fix-code-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-fix-code-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-fix-code-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: cpumask: fix code comment

Fix code comment for cpumask_parse().

Link: http://lkml.kernel.org/r/71aae2c60ae5dae0cf554199ce6aea8f88c69347.1465380581.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
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

cpumask-fix-code-comment.patch

