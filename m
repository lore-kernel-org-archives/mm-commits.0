From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:05:49 -0800
Message-ID: <20111214200551.191FC10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:43647 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:05:58 -0500
Received: by yhjj51 with SMTP id j51so241042yhj.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:05:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c  |    3 ---
 drivers/mmc/card/block.c |    4 ----
 2 files changed, 7 deletions(-)

diff -puN arch/arm/kernel/setup.c~linux-next-git-rejects arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~linux-next-git-rejects
+++ a/arch/arm/kernel/setup.c
@@ -910,7 +910,6 @@ void __init setup_arch(char **cmdline_p)
 	machine_desc = mdesc;
 	machine_name = mdesc->name;
 
-<<<<<<< HEAD
 #ifdef CONFIG_ZONE_DMA
 	if (mdesc->dma_zone_size) {
 		extern unsigned long arm_dma_zone_size;
@@ -919,10 +918,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	if (mdesc->soft_reboot)
 		reboot_setup("s");
-=======
 	if (mdesc->restart_mode)
 		reboot_setup(&mdesc->restart_mode);
->>>>>>> linux-next/akpm-end
 
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
diff -puN drivers/mmc/card/block.c~linux-next-git-rejects drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~linux-next-git-rejects
+++ a/drivers/mmc/card/block.c
@@ -1733,11 +1733,7 @@ static const struct mmc_fixup blk_fixups
 	 * Some Micron MMC cards needs longer data read timeout than
 	 * indicated in CSD.
 	 */
-<<<<<<< HEAD
-	MMC_FIXUP(CID_NAME_ANY, 0x13, 0x200, add_quirk_mmc,
-=======
 	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_MICRON, 0x200, add_quirk_mmc,
->>>>>>> linux-next/akpm-end
 		  MMC_QUIRK_LONG_READ_TIME),
 
 	END_FIXUP
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

