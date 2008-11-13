From: akpm@linux-foundation.org
Subject: + kconfig-correct-sched-rt-grouptxt-pathname-in-init-kconfig.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:23:55 -0800
Message-ID: <200811130023.mAD0NtS6018254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbYKMAYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:24:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adi@drcomp.erfurt.thur.de, mingo@elte.hu


The patch titled
     Kconfig: correct sched-rt-group.txt pathname in init/Kconfig
has been added to the -mm tree.  Its filename is
     kconfig-correct-sched-rt-grouptxt-pathname-in-init-kconfig.patch

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
Subject: Kconfig: correct sched-rt-group.txt pathname in init/Kconfig
From: Adrian Knoth <adi@drcomp.erfurt.thur.de>

init/Kconfig directs the user to Documentation/sched-rt-group.txt, but
the file is actually in Documentation/scheduler/sched-rt-group.txt.

This patch corrects the pathname mentioned in init/Kconfig.

Signed-off-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~kconfig-correct-sched-rt-grouptxt-pathname-in-init-kconfig init/Kconfig
--- a/init/Kconfig~kconfig-correct-sched-rt-grouptxt-pathname-in-init-kconfig
+++ a/init/Kconfig
@@ -354,7 +354,7 @@ config RT_GROUP_SCHED
 	  setting below. If enabled, it will also make it impossible to
 	  schedule realtime tasks for non-root users until you allocate
 	  realtime bandwidth for them.
-	  See Documentation/sched-rt-group.txt for more information.
+ 	  See Documentation/scheduler/sched-rt-group.txt for more information.
 
 choice
 	depends on GROUP_SCHED
_

Patches currently in -mm which might be from adi@drcomp.erfurt.thur.de are

kconfig-correct-sched-rt-grouptxt-pathname-in-init-kconfig.patch

