From: akpm@linux-foundation.org
Subject: [folded] arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:43:02 -0700
Message-ID: <200904141943.n3EJh28d016537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbZDNTpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jaswinder@kernel.org, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix.patch

This patch was dropped because it was folded into arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix
From: Andrew Morton <akpm@linux-foundation.org>

doh

Cc: Len Brown <len.brown@intel.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -197,7 +197,7 @@ static void do_drv_write(void *_cmd)
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	int target_cpu;		/* The CPU on which to perform thr rdmsr() */
+	int target_cpu;		/* The CPU on which to perform the rdmsr() */
 	int this_cpu;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-dont-open-code-smp_call_function_many.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
readahead-introduce-context-readahead-algorithm-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

