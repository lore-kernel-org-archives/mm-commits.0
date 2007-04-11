From: akpm@linux-foundation.org
Subject: - input-replace-more-deprecated-sa_xxx-interrupt-flags.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:21:01 -0700
Message-ID: <200704112321.l3BNL1Sh017536@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbXDKXVJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: replace more deprecated SA_xxx interrupt flags
has been removed from the -mm tree.  Its filename was
     input-replace-more-deprecated-sa_xxx-interrupt-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: input: replace more deprecated SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>

Fix the obnoxious users of the deprecated SA_xxx interrupt flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/pxa27x_keyboard.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/keyboard/pxa27x_keyboard.c~input-replace-more-deprecated-sa_xxx-interrupt-flags drivers/input/keyboard/pxa27x_keyboard.c
--- a/drivers/input/keyboard/pxa27x_keyboard.c~input-replace-more-deprecated-sa_xxx-interrupt-flags
+++ a/drivers/input/keyboard/pxa27x_keyboard.c
@@ -181,7 +181,7 @@ static int __devinit pxakbd_probe(struct
 		}
 	}
 
-	error = request_irq(IRQ_KEYPAD, pxakbd_irq_handler, SA_INTERRUPT,
+	error = request_irq(IRQ_KEYPAD, pxakbd_irq_handler, IRQF_DISABLED,
 			    DRIVER_NAME, pdev);
 	if (error) {
 		printk(KERN_ERR "Cannot request keypad IRQ\n");
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-arm.patch
git-ieee1394.patch
git-input.patch
vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch
i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
replace-deprecated-sa_xxx-interrupt-flags.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
pad-irq_desc-to-internode-cacheline-size.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
