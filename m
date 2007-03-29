From: akpm@linux-foundation.org
Subject: - apmc-get-rid-of-unused-variables.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:19 -0700
Message-ID: <200703292339.l2TNdJmp015422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43187 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945942AbXC2XjV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: parag.warudkar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     apm.c: get rid of unused variables
has been removed from the -mm tree.  Its filename was
     apmc-get-rid-of-unused-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: apm.c: get rid of unused variables
From: Parag Warudkar <parag.warudkar@gmail.com>

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN arch/i386/kernel/apm.c~apmc-get-rid-of-unused-variables arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~apmc-get-rid-of-unused-variables
+++ a/arch/i386/kernel/apm.c
@@ -384,13 +384,6 @@ static int			ignore_sys_suspend;
 static int			ignore_normal_resume;
 static int			bounce_interval __read_mostly = DEFAULT_BOUNCE_INTERVAL;
 
-#ifdef CONFIG_APM_RTC_IS_GMT
-#	define	clock_cmos_diff	0
-#	define	got_clock_diff	1
-#else
-static long			clock_cmos_diff;
-static int			got_clock_diff;
-#endif
 static int			debug __read_mostly;
 static int			smp __read_mostly;
 static int			apm_disabled = -1;
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

fdomainc-get-rid-of-unused-stuff.patch
