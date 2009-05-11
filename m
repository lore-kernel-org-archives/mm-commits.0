From: akpm@linux-foundation.org
Subject: [merged] mtd-fix-timeout-in-m25p80-driver-fix.patch removed from -mm tree
Date: Mon, 11 May 2009 11:54:27 -0700
Message-ID: <200905111854.n4BIsRmh000360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbZEKS6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 14:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, sfalco@harris.com, tbm@cyrius.com, zero@colonel-panic.org, mm-commits@vger.kernel.org


The patch titled
     mtd-fix-timeout-in-m25p80-driver-fix
has been removed from the -mm tree.  Its filename was
     mtd-fix-timeout-in-m25p80-driver-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd-fix-timeout-in-m25p80-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix merge snafu

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Peter Horton <zero@colonel-panic.org>
Cc: Steven A. Falco <sfalco@harris.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-fix-timeout-in-m25p80-driver-fix drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-fix-timeout-in-m25p80-driver-fix
+++ a/drivers/mtd/devices/m25p80.c
@@ -54,7 +54,7 @@
 #define	SR_SRWD			0x80	/* SR write protect */
 
 /* Define max times to check status register before we give up. */
-#define	MAX_READY_WAIT_COUNT	(10 * HZ) /* eg. M25P128 specs 6s max sector erase */
+#define	MAX_READY_WAIT_JIFFIES	(10 * HZ) /* eg. M25P128 specs 6s max sector erase */
 #define	CMD_SIZE		4
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
alpha-unbreak-percpu-again.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
revert-acpi-idle-mark_tsc_unstable-at-init-time-not-run-time.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

