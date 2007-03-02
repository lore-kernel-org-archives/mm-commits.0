From: akpm@linux-foundation.org
Subject: - update-timekeeping_is_continuous-comment.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:14 -0800
Message-ID: <200703020506.l2256Ec5000777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422700AbXCBFG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     update timekeeping_is_continuous comment
has been removed from the -mm tree.  Its filename was
     update-timekeeping_is_continuous-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update timekeeping_is_continuous comment
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~update-timekeeping_is_continuous-comment kernel/timer.c
--- a/kernel/timer.c~update-timekeeping_is_continuous-comment
+++ a/kernel/timer.c
@@ -908,7 +908,7 @@ static inline void change_clocksource(vo
 #endif
 
 /**
- * timeofday_is_continuous - check to see if timekeeping is free running
+ * timekeeping_is_continuous - check to see if timekeeping is free running
  */
 int timekeeping_is_continuous(void)
 {
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
panic-on-slim-selinux.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
profile-likely-unlikely-macros-x86_64-fix.patch
