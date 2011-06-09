From: akpm@linux-foundation.org
Subject: [obsolete] rtc-fix-build-warnings-in-defconfigs-fix.patch removed from -mm tree
Date: Thu, 09 Jun 2011 14:54:41 -0700
Message-ID: <201106092154.p59Lsfvx002304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756135Ab1FIVyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 17:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gxt@mprc.pku.edu.cn, wanlong.gao@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rtc-fix-build-warnings-in-defconfigs-fix
has been removed from the -mm tree.  Its filename was
     rtc-fix-build-warnings-in-defconfigs-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-fix-build-warnings-in-defconfigs-fix
From: Andrew Morton <akpm@linux-foundation.org>

revert unicore32 part

Cc: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/configs/debug_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/unicore32/configs/debug_defconfig~rtc-fix-build-warnings-in-defconfigs-fix arch/unicore32/configs/debug_defconfig
--- a/arch/unicore32/configs/debug_defconfig~rtc-fix-build-warnings-in-defconfigs-fix
+++ a/arch/unicore32/configs/debug_defconfig
@@ -168,7 +168,7 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 
 #	Real Time Clock
 CONFIG_RTC_LIB=m
-CONFIG_RTC_CLASS=y
+CONFIG_RTC_CLASS=m
 
 ### File systems
 CONFIG_EXT2_FS=m
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
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
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
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

