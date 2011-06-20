From: akpm@linux-foundation.org
Subject: + maintainers-update-high-resolution-timers-patterns.patch added to -mm tree
Date: Mon, 20 Jun 2011 16:34:27 -0700
Message-ID: <201106202334.p5KNYRGW030014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131Ab1FTXek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 19:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, tglx@linutronix.de


The patch titled
     MAINTAINERS: update HIGH RESOLUTION TIMERS patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-high-resolution-timers-patterns.patch

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
@@ -3000,7 +3000,7 @@ F:	kernel/hrtimer.c
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
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
get_maintainerspl-improve-mailmap-parsing.patch
maintainers-update-high-resolution-timers-patterns.patch
maintainers-remove-section-usb-se401-driver.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch
checkpatch-add-a-prefer-__aligned-check.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

