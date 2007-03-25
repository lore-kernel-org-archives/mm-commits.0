From: akpm@linux-foundation.org
Subject: + apmc-get-rid-of-unused-variables.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:31:01 -0800
Message-ID: <200703252231.l2PMV1YR004269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32928 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbXCYWbD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com


The patch titled
     apm.c: get rid of unused variables
has been added to the -mm tree.  Its filename is
     apmc-get-rid-of-unused-variables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

make-aout-executables-work-again.patch
make-aout-executables-work-again-fix.patch
apmc-get-rid-of-unused-variables.patch
keyboardc-stop-flooding-dmesg-with-useless-warnings.patch
