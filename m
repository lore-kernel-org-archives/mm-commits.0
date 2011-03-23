From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-missing-after-hr-timers-f-tag.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:45 -0700
Message-ID: <201103232043.p2NKhLfv028856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933436Ab1CWUn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, harryxiyou@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add missing : after HR Timers F tag
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-after-hr-timers-f-tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add missing : after HR Timers F tag
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-add-missing-after-hr-timers-f-tag MAINTAINERS
--- a/MAINTAINERS~maintainers-add-missing-after-hr-timers-f-tag
+++ a/MAINTAINERS
@@ -3005,7 +3005,7 @@ F:	kernel/hrtimer.c
 F:	kernel/time/clockevents.c
 F:	kernel/time/tick*.*
 F:	kernel/time/timer_*.c
-F	include/linux/clockevents.h
+F:	include/linux/clockevents.h
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

