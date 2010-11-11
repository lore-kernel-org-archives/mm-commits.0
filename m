From: akpm@linux-foundation.org
Subject: + lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch added to -mm tree
Date: Thu, 11 Nov 2010 11:20:34 -0800
Message-ID: <201011111920.oABJKYp0030140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab0KKTVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 14:21:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, br1@einfach.org, kosaki.motohiro@jp.fujitsu.com, linville@tuxdriver.com, randy.dunlap@oracle.com, stefanr@s5r6.in-berlin.de


The patch titled
     lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix
has been added to the -mm tree.  Its filename is
     lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch

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
Subject: lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix
From: Andrew Morton <akpm@linux-foundation.org>

include bug.h, per Stefan.

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/average.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/average.c~lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix lib/average.c
--- a/lib/average.c~lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix
+++ a/lib/average.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/average.h>
+#include <linux/bug.h>
 
 /**
  * DOC: Exponentially Weighted Moving Average (EWMA)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
restrict-unprivileged-access-to-kernel-syslog-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
lib-add-generic-exponentially-weighted-moving-average-ewma-function-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

