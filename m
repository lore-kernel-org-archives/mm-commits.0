From: akpm@linux-foundation.org
Subject: + cpuidle-menu-governor-and-hrtimer-compile-fix.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:48:52 -0700
Message-ID: <200706080048.l580mqWY014041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933800AbXFHAtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: menu governor and hrtimer compile fix
has been added to the -mm tree.  Its filename is
     cpuidle-menu-governor-and-hrtimer-compile-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
