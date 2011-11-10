From: akpm@linux-foundation.org
Subject: [folded] lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch removed from -mm tree
Date: Wed, 09 Nov 2011 16:16:36 -0800
Message-ID: <201111100016.pAA0Ga9s028583@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:42187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab1KJAQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 19:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eric.dumazet@gmail.com, fzago@systemfabricworks.com, roland@kernel.org, rpearson@systemfabricworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
has been removed from the -mm tree.  Its filename was
     lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch

This patch was dropped because it was folded into lib-crc-add-slice-by-8-algorithm-to-crc32c.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-crc-add-slice-by-8-algorithm-to-crc32c-fix

don't include asm/msr.h

Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: frank zago <fzago@systemfabricworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN lib/crc32.c~lib-crc-add-slice-by-8-algorithm-to-crc32c-fix lib/crc32.c
--- a/lib/crc32.c~lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
+++ a/lib/crc32.c
@@ -32,8 +32,6 @@
 #include <linux/atomic.h>
 #include "crc32defs.h"
 
-#include <asm/msr.h>
-
 #if CRC_LE_BITS > 8
 # define tole(x) (__force u32) __constant_cpu_to_le32(x)
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

