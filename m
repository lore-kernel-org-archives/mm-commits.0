From: akpm@linux-foundation.org
Subject: [folded] writeback-sync-expired-inodes-first-in-background-writeback-fix.patch removed from -mm tree
Date: Wed, 01 Jun 2011 15:26:54 -0700
Message-ID: <201106012226.p51MQsPn013351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab1FAW04 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:26:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     writeback-sync-expired-inodes-first-in-background-writeback-fix
has been removed from the -mm tree.  Its filename was
     writeback-sync-expired-inodes-first-in-background-writeback-fix.patch

This patch was dropped because it was folded into writeback-sync-expired-inodes-first-in-background-writeback.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-sync-expired-inodes-first-in-background-writeback-fix
From: Andrew Morton <akpm@linux-foundation.org>

tweak a comment

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~writeback-sync-expired-inodes-first-in-background-writeback-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-sync-expired-inodes-first-in-background-writeback-fix
+++ a/fs/fs-writeback.c
@@ -744,10 +744,10 @@ retry:
 		if (wbc.inodes_cleaned)
 			continue;
 		/*
-		 * background writeback will start with expired inodes, and
-		 * if none is found, fallback to all inodes. This order helps
-		 * reduce the number of dirty pages reaching the end of LRU
-		 * lists and cause trouble to the page reclaim.
+		 * background writeback will start with expired inodes and if
+		 * none are found, fall back to all inodes. This order helps
+		 * reduce the number of dirty pages reaching the end of LRU lists
+		 * and causing difficulty in page reclaim.
 		 */
 		if (work->for_background &&
 		    wbc.older_than_this &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

