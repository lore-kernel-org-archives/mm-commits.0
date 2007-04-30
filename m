From: akpm@linux-foundation.org
Subject: - vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:36:43 -0700
Message-ID: <200704302136.l3ULahiL015479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423699AbXD3Vh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, jeff@garzik.org, schidambaram@fabric7.com, mm-commits@vger.kernel.org


The patch titled
     vioc: replace more deprecated SA_xxx interrupt flags
has been removed from the -mm tree.  Its filename was
     vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: vioc: replace more deprecated SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>

Fix the obnoxious users of the deprecated SA_xxx interrupt flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Sriram Chidambaram <schidambaram@fabric7.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/vioc/vioc_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/vioc/vioc_irq.c~vioc-replace-more-deprecated-sa_xxx-interrupt-flags drivers/net/vioc/vioc_irq.c
--- a/drivers/net/vioc/vioc_irq.c~vioc-replace-more-deprecated-sa_xxx-interrupt-flags
+++ a/drivers/net/vioc/vioc_irq.c
@@ -319,7 +319,7 @@ static int vioc_irq_install(struct pci_d
 
 	ret = request_irq(vioc_interrupts[vioc_id].intreq[intr_id].irq,
 			  vioc_interrupts[vioc_id].intreq[intr_id].hthandler,
-			  SA_INTERRUPT,
+			  IRQF_DISABLED,
 			  vioc_interrupts[vioc_id].intreq[intr_id].name,
 			  vioc_interrupts[vioc_id].intreq[intr_id].
 			  intrFuncparm);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-arm.patch
git-avr32.patch
git-ieee1394.patch
git-input.patch
vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch
h8300-generic-irq.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
replace-deprecated-sa_xxx-interrupt-flags.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
pad-irq_desc-to-internode-cacheline-size.patch
highres-dyntick-prevent-xtime-lock-contention.patch
introduce-a-handy-list_first_entry-macro-v2.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
