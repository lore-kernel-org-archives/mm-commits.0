From: akpm@linux-foundation.org
Subject: + maintainers-correct-entry-for-legacy-rtc-driver.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:54:52 -0700
Message-ID: <201009072254.o87MsqQ6011347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757746Ab0IGWz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, a.zummo@towertech.it, p_gortmaker@yahoo.com, vapier@gentoo.org


The patch titled
     MAINTAINERS: correct entry for legacy RTC-driver
has been added to the -mm tree.  Its filename is
     maintainers-correct-entry-for-legacy-rtc-driver.patch

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
Subject: MAINTAINERS: correct entry for legacy RTC-driver
From: Wolfram Sang <w.sang@pengutronix.de>

Because no one dared to remove it so far, let's keep the entry correct, at
least.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-correct-entry-for-legacy-rtc-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-correct-entry-for-legacy-rtc-driver
+++ a/MAINTAINERS
@@ -4868,12 +4868,10 @@ F:	kernel/rcu*
 F:	kernel/srcu*
 X:	kernel/rcutorture.c
 
-REAL TIME CLOCK DRIVER
+REAL TIME CLOCK DRIVER (LEGACY)
 M:	Paul Gortmaker <p_gortmaker@yahoo.com>
 S:	Maintained
-F:	Documentation/rtc.txt
-F:	drivers/rtc/
-F:	include/linux/rtc.h
+F:	drivers/char/rtc.c
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
maintainers-correct-entry-for-legacy-rtc-driver.patch
sdhci-turn-timeout-timer-into-delayed-work.patch
sdhci-use-work-structs-instead-of-tasklets.patch
sdhci-use-work-structs-instead-of-tasklets-fix.patch
sdhci-clear-interrupt-status-register-just-once.patch
sdhci-use-threaded-irq-handler.patch
sdhci-turn-host-lock-into-a-mutex.patch
sdhci-get-rid-of-card-detect-work.patch
sdhci-get-rid-of-card-detect-work-fix.patch
sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
sdhci-use-jiffies-instead-of-a-timeout-counter.patch
rtc-rtc-lpc32xx-introduce-rtc-driver-for-the-lpc32xx-soc-v4.patch

