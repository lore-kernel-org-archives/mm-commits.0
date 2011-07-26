From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-high-resolution-timers-patterns.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:40 -0700
Message-ID: <201107260754.p6Q7shhV003377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab1GZHzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update HIGH RESOLUTION TIMERS patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-high-resolution-timers-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update HIGH RESOLUTION TIMERS patterns
From: Joe Perches <joe@perches.com>

clockchips.h was typoed as clockevents.h

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-high-resolution-timers-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-high-resolution-timers-patterns
+++ a/MAINTAINERS
@@ -3012,7 +3012,7 @@ F:	kernel/hrtimer.c
 F:	kernel/time/clockevents.c
 F:	kernel/time/tick*.*
 F:	kernel/time/timer_*.c
-F:	include/linux/clockevents.h
+F:	include/linux/clockchips.h
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-orphan-framerelay-dlci.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

