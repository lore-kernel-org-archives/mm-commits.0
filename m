From: akpm@linux-foundation.org
Subject: [folded] atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 11 Nov 2010 13:50:43 -0800
Message-ID: <201011112150.oABLohTl004605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619Ab0KKVvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 16:51:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eric.dumazet@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     atomic-add-atomic_inc_not_zero_hint-checkpatch-fixes.patch

This patch was dropped because it was folded into atomic-add-atomic_inc_not_zero_hint.patch

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

origin.patch
hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
restrict-unprivileged-access-to-kernel-syslog-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-low-threshold-to-pwm-backlight.patch
arch-x86-kernel-entry_32s-work-around-gas-2161-glitch.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch

