From: akpm@linux-foundation.org
Subject: [nacked] stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix.patch removed from -mm tree
Date: Thu, 02 Jul 2009 00:34:30 -0700
Message-ID: <200907020734.n627YUjZ028632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZGBHfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 03:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, holt@sgi.com, rusty@rustcorp.com.au, stable@kernel.org, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix
has been removed from the -mm tree.  Its filename was
     stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix
From: Andrew Morton <akpm@linux-foundation.org>

repair comment spelling and layout.

Cc: <stable@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/stop_machine.c~stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix
+++ a/kernel/stop_machine.c
@@ -14,11 +14,11 @@
 #include <asm/uaccess.h>
 
 /*
- * It is important to keep 'thread_ack' and 'state' in a seperate
- * cachelines to prevent cacheline sharing between threads updating
- * thread_ack and other threads spinning on state.
+ * It is important to keep 'thread_ack' and 'state' in separate cachelines to
+ * prevent cacheline sharing between threads updating thread_ack and other
+ * threads spinning on state.
  */
-static atomic_t thread_ack	____cacheline_aligned;
+static atomic_t thread_ack ____cacheline_aligned;
 
 /* This controls the threads on each CPU. */
 enum stopmachine_state {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

