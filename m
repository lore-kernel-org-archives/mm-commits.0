From: akpm@linux-foundation.org
Subject: [merged] mm-oom_killc-fix-a-typo.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:13 -0700
Message-ID: <552fe881.FaI2lPZiEkYQ/7mO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbbDPQpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix typo in comment
has been removed from the -mm tree.  Its filename was
     mm-oom_killc-fix-a-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/oom_kill.c: fix typo in comment

Alter 'taks' -> 'task'

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_killc-fix-a-typo mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_killc-fix-a-typo
+++ a/mm/oom_kill.c
@@ -408,7 +408,7 @@ bool oom_killer_disabled __read_mostly;
 static DECLARE_RWSEM(oom_sem);
 
 /**
- * mark_tsk_oom_victim - marks the given taks as OOM victim.
+ * mark_tsk_oom_victim - marks the given task as OOM victim.
  * @tsk: task to mark
  *
  * Has to be called with oom_sem taken for read and never after
_

Patches currently in -mm which might be from bywxiaobai@163.com are

origin.patch
linux-next.patch

