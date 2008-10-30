From: akpm@linux-foundation.org
Subject: + mm-oom_killc-fix-badness-kerneldoc.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:47:53 -0700
Message-ID: <200810302147.m9ULlr49025182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758358AbYJ3VuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, rdunlap@xenotime.net


The patch titled
     mm/oom_kill.c: fix badness() kerneldoc
has been added to the -mm tree.  Its filename is
     mm-oom_killc-fix-badness-kerneldoc.patch

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
Subject: mm/oom_kill.c: fix badness() kerneldoc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

Paramter @mem has been removed since v2.6.26, now delete it's comment.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_killc-fix-badness-kerneldoc mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_killc-fix-badness-kerneldoc
+++ a/mm/oom_kill.c
@@ -38,7 +38,6 @@ static DEFINE_SPINLOCK(zone_scan_mutex);
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
  * @uptime: current uptime in seconds
- * @mem: target memory controller
  *
  * The formula used is relatively simple and documented inline in the
  * function. The main rationale is that we want to select a good task
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
mm-oom_killc-fix-badness-kerneldoc.patch
linux-next.patch

