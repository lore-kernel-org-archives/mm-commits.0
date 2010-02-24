From: akpm@linux-foundation.org
Subject: [merged] posix-timersc-dont-export-local-functions.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:40:09 -0800
Message-ID: <201002241940.o1OJe9ZX016348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757862Ab0BXTkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers.c: don't export local functions
has been removed from the -mm tree.  Its filename was
     posix-timersc-dont-export-local-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers.c: don't export local functions
From: H Hartley Sweeten <hartleys@visionengravers.com>

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/posix-timers.c~posix-timersc-dont-export-local-functions kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timersc-dont-export-local-functions
+++ a/kernel/posix-timers.c
@@ -256,7 +256,7 @@ static int posix_get_monotonic_coarse(cl
 	return 0;
 }
 
-int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
 {
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
scsi-sdc-quiet-all-sparse-noise.patch
init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch
nodemaskh-remove-macro-any_online_node.patch
init-mainc-make-setup_max_cpus-static-for-smp.patch
rtc-ep93xxc-cleanup-probe-remove-routines.patch

