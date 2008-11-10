From: akpm@linux-foundation.org
Subject: - mm-oom_killc-fix-badness-kerneldoc.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:42 -0800
Message-ID: <200811102032.mAAKWgvK024092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041AbYKJUdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     mm/oom_kill.c: fix badness() kerneldoc
has been removed from the -mm tree.  Its filename was
     mm-oom_killc-fix-badness-kerneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


