From: akpm@linux-foundation.org
Subject: - kconfig-correct-sched-rt-grouptxt-pathname-in-init-kconfig.patch removed from -mm tree
Date: Wed, 19 Nov 2008 12:47:58 -0800
Message-ID: <200811192047.mAJKlwqE007164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbYKSUsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 15:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adi@drcomp.erfurt.thur.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Kconfig: correct sched-rt-group.txt pathname in init/Kconfig
has been removed from the -mm tree.  Its filename was
     kconfig-correct-sched-rt-grouptxt-pathname-in-init-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

