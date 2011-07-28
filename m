From: akpm@linux-foundation.org
Subject: + lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:16:47 -0700
Message-ID: <201107282216.p6SMGlbf011659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091Ab1G1WSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eric.dumazet@gmail.com, fzago@systemfabricworks.com, roland@kernel.org, rpearson@systemfabricworks.com


The patch titled
     lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
has been added to the -mm tree.  Its filename is
     lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch

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
Subject: lib-crc-add-slice-by-8-algorithm-to-crc32c-fix
From: Andrew Morton <akpm@linux-foundation.org>

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

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

