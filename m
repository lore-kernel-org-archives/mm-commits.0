From: akpm@linux-foundation.org
Subject: - clockevents-remove-prototypes-of-removed-functions.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:58 -0700
Message-ID: <200707230933.l6N9XwkJ016337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759099AbXGWJpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     clockevents: remove prototypes of removed functions
has been removed from the -mm tree.  Its filename was
     clockevents-remove-prototypes-of-removed-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clockevents: remove prototypes of removed functions
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clockchips.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/clockchips.h~clockevents-remove-prototypes-of-removed-functions include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockevents-remove-prototypes-of-removed-functions
+++ a/include/linux/clockchips.h
@@ -119,10 +119,6 @@ extern void clockevents_register_device(
 
 extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
-extern
-struct clock_event_device *clockevents_request_device(unsigned int features,
-						      cpumask_t cpumask);
-extern void clockevents_release_device(struct clock_event_device *dev);
 extern void clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
 extern int clockevents_register_notifier(struct notifier_block *nb);
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
