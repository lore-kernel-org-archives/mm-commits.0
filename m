From: akpm@linux-foundation.org
Subject: + writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch added to -mm tree
Date: Wed, 10 Nov 2010 13:56:38 -0800
Message-ID: <201011102156.oAALuc57008115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756932Ab0KJV5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 16:57:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, jengelh@medozas.de


The patch titled
     writeback-check-skipped-pages-on-wb_sync_all-update-fix
has been added to the -mm tree.  Its filename is
     writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch

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
Subject: writeback-check-skipped-pages-on-wb_sync_all-update-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Hellwig <hch@lst.de> 
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-check-skipped-pages-on-wb_sync_all-update-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-check-skipped-pages-on-wb_sync_all-update-fix
+++ a/fs/fs-writeback.c
@@ -530,7 +530,7 @@ static int writeback_sb_inodes(struct su
 			/*
 			 * There's no logic to retry skipped pages for sync(),
 			 * filesystems are assumed not to skip dirty pages on
-			 * temporal lock contentions or non fatal errors.
+			 * temporary lock contentions or non fatal errors.
 			 */
 			WARN_ON_ONCE(wbc->sync_mode == WB_SYNC_ALL);
 		}
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
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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

