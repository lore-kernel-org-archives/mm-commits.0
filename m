From: akpm@linux-foundation.org
Subject: + irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch added to -mm tree
Date: Mon, 08 Nov 2010 16:33:11 -0800
Message-ID: <201011090033.oA90XBCb018865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab0KIAdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 19:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eric.dumazet@gmail.com, tglx@linutronix.de


The patch titled
     irq-use-per_cpu-kstat_irqs-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch

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
Subject: irq-use-per_cpu-kstat_irqs-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#169: FILE: kernel/irq/irqdesc.c:283:
+^I$

WARNING: line over 80 characters
#173: FILE: kernel/irq/irqdesc.c:287:
+			unsigned int __percpu *stats = alloc_percpu(unsigned int);

total: 1 errors, 1 warnings, 152 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/irq-use-per_cpu-kstat_irqs.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/irqdesc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/irqdesc.c~irq-use-per_cpu-kstat_irqs-checkpatch-fixes kernel/irq/irqdesc.c
--- a/kernel/irq/irqdesc.c~irq-use-per_cpu-kstat_irqs-checkpatch-fixes
+++ a/kernel/irq/irqdesc.c
@@ -280,7 +280,7 @@ static inline int alloc_descs(unsigned i
 #if defined(CONFIG_KSTAT_IRQS_ONDEMAND)
 	struct irq_desc *desc;
 	unsigned int i;
-	
+
 	for (i = 0; i < cnt; i++) {
 		desc = irq_to_desc(start + i);
 		if (desc && !desc->kstat_irqs) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
include-linux-kernelh-roundup-work-around-a-gcc-33-miscompile.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

