From: akpm@linux-foundation.org
Subject: + pm-drop-unnecessary-includes-from-pmh.patch added to -mm tree
Date: Mon, 23 Jun 2008 20:44:41 -0700
Message-ID: <200806240344.m5O3ifFT031180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbYFXDor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 23:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@suse.cz


The patch titled
     pm: drop unnecessary includes from pm.h
has been added to the -mm tree.  Its filename is
     pm-drop-unnecessary-includes-from-pmh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: drop unnecessary includes from pm.h
From: Rafael J. Wysocki <rjw@sisk.pl>

Drop unnecessary includes from include/linux/pm.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/pm.h~pm-drop-unnecessary-includes-from-pmh include/linux/pm.h
--- a/include/linux/pm.h~pm-drop-unnecessary-includes-from-pmh
+++ a/include/linux/pm.h
@@ -22,8 +22,6 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
-#include <asm/atomic.h>
-#include <asm/errno.h>
 
 /*
  * Callbacks for platform drivers to implement.
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-remove-references-to-struct-pm_dev-from-irda-headers.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
remove-include-linux-pm_legacyh.patch
pm-remove-definition-of-struct-pm_dev.patch
pm-remove-remaining-obsolete-definitions-from-pmh.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
pm-drop-unnecessary-includes-from-pmh.patch
shrink_slab-handle-bad-shrinkers.patch

