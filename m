From: akpm@linux-foundation.org
Subject: + atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch added to -mm tree
Date: Fri, 05 Nov 2010 12:43:06 -0700
Message-ID: <201011051943.oA5Jh6JH028992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab0KETng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 15:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eric.dumazet@gmail.com


The patch titled
     atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch

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
Subject: atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#64: FILE: include/linux/atomic.h:26:
+ ^Ido {$

WARNING: please, no space before tabs
#64: FILE: include/linux/atomic.h:26:
+ ^Ido {$

WARNING: please, no spaces at the start of a line
#64: FILE: include/linux/atomic.h:26:
+ ^Ido {$

total: 1 errors, 2 warnings, 37 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/atomic-add-atomic_inc_not_zero_hint.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/atomic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/atomic.h~atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes include/linux/atomic.h
--- a/include/linux/atomic.h~atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes
+++ a/include/linux/atomic.h
@@ -23,7 +23,7 @@ static inline int atomic_inc_not_zero_hi
 	if (!hint)
 		return atomic_inc_not_zero(v);
 
- 	do {
+	do {
 		val = atomic_cmpxchg(v, c, c + 1);
 		if (val == c)
 			return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch
linux-next.patch
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
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

