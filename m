From: akpm@linux-foundation.org
Subject: + mm-oom_killc-fix-a-typo.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:53:33 -0700
Message-ID: <5501fccd.VMg7dCuGUNO1XHwX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbbCLUxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix typo in comment
has been added to the -mm tree.  Its filename is
     mm-oom_killc-fix-a-typo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_killc-fix-a-typo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_killc-fix-a-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_allocc-add-and-in-comment.patch
mm-oom_killc-fix-a-typo.patch

