From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-unused-timekeeping-timekeepingh.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:56 -0700
Message-ID: <201103232043.p2NKhW0L028879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755895Ab1CWUzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove unused TIMEKEEPING timekeeping.h
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unused-timekeeping-timekeepingh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove unused TIMEKEEPING timekeeping.h
From: Joe Perches <joe@perches.com>

Commit 88606e80da0 ("MAINTAINERS: Update timer related entries") added a
file pattern that didn't actually exist.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unused-timekeeping-timekeepingh MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unused-timekeeping-timekeepingh
+++ a/MAINTAINERS
@@ -5420,7 +5420,6 @@ S:	Supported
 F:	include/linux/clocksource.h
 F:	include/linux/time.h
 F:	include/linux/timex.h
-F:	include/linux/timekeeping.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

