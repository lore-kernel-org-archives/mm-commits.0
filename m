From: akpm@linux-foundation.org
Subject: - cpuidle-menu-governor-and-hrtimer-compile-fix.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:51:25 -0700
Message-ID: <200707060051.l660pPFS028218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760616AbXGFAvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle: menu governor and hrtimer compile fix
has been removed from the -mm tree.  Its filename was
     cpuidle-menu-governor-and-hrtimer-compile-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuidle: menu governor and hrtimer compile fix
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Compile fix for menu governor.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-and-hrtimer-compile-fix drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-and-hrtimer-compile-fix
+++ a/drivers/cpuidle/governors/menu.c
@@ -11,8 +11,8 @@
 #include <linux/latency.h>
 #include <linux/time.h>
 #include <linux/ktime.h>
-#include <linux/tick.h>
 #include <linux/hrtimer.h>
+#include <linux/tick.h>
 
 #define BM_HOLDOFF	20000	/* 20 ms */
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
git-newsetup.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
