From: akpm@linux-foundation.org
Subject: + fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch added to -mm tree
Date: Mon, 08 Nov 2010 14:43:06 -0800
Message-ID: <201011082243.oA8Mh6MA014135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401Ab0KHWnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 17:43:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com


The patch titled
     fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

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
Subject: fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#36: FILE: fs/proc/base.c:382:
+^I^I^I^Iunsigned long bt = lr->backtrace[q]; $

ERROR: trailing whitespace
#73: FILE: kernel/latencytop.c:252:
+^I^I^I^Iunsigned long bt = lr->backtrace[q]; $

total: 2 errors, 0 warnings, 65 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |    2 +-
 kernel/latencytop.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
+++ a/fs/proc/base.c
@@ -379,7 +379,7 @@ static int lstats_show_proc(struct seq_f
 			seq_printf(m, "%i %li %li",
 				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				unsigned long bt = lr->backtrace[q]; 
+				unsigned long bt = lr->backtrace[q];
 				if (!bt)
 					break;
 				if (bt == ULONG_MAX)
diff -puN kernel/latencytop.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes kernel/latencytop.c
--- a/kernel/latencytop.c~fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes
+++ a/kernel/latencytop.c
@@ -249,7 +249,7 @@ static int lstats_show(struct seq_file *
 			seq_printf(m, "%i %lu %lu",
 				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				unsigned long bt = lr->backtrace[q]; 
+				unsigned long bt = lr->backtrace[q];
 				if (!bt)
 					break;
 				if (bt == ULONG_MAX)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
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

