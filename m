From: akpm@linux-foundation.org
Subject: [folded] rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 03 Jun 2011 16:44:05 -0700
Message-ID: <201106032344.p53Ni56K015146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab1FCXoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Priyanka.Jain@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rtc-driver-for-pt7c4338-chip-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-driver-for-pt7c4338-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-driver-for-pt7c4338-chip-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: missing space after struct definition
#128: FILE: drivers/rtc/rtc-pt7c4338.c:70:
+struct pt7c4338{

total: 0 errors, 1 warnings, 237 lines checked

./patches/rtc-driver-for-pt7c4338-chip.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Priyanka Jain <Priyanka.Jain@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pt7c4338.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pt7c4338.c~rtc-driver-for-pt7c4338-chip-checkpatch-fixes drivers/rtc/rtc-pt7c4338.c
--- a/drivers/rtc/rtc-pt7c4338.c~rtc-driver-for-pt7c4338-chip-checkpatch-fixes
+++ a/drivers/rtc/rtc-pt7c4338.c
@@ -67,7 +67,7 @@ static const struct i2c_device_id pt7c43
 };
 MODULE_DEVICE_TABLE(i2c, pt7c4338_id);
 
-struct pt7c4338{
+struct pt7c4338 {
 	struct i2c_client *client;
 	struct rtc_device *rtc;
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
rtc-driver-for-pt7c4338-chip.patch
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

