From: akpm@linux-foundation.org
Subject: [folded] fix-virt_to_phys-warnings-fix.patch removed from -mm tree
Date: Sun, 05 Jul 2009 11:42:45 -0700
Message-ID: <200907051842.n65IgjaW012679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbZGESnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 5 Jul 2009 14:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, cernekee@gmail.com, mingo@elte.hu, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     fix-virt_to_phys-warnings-fix
has been removed from the -mm tree.  Its filename was
     fix-virt_to_phys-warnings-fix.patch

This patch was dropped because it was folded into fix-virt_to_phys-warnings.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix-virt_to_phys-warnings-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix kernel/perf_counter.c too.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/perf_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/perf_counter.c~fix-virt_to_phys-warnings-fix kernel/perf_counter.c
--- a/kernel/perf_counter.c~fix-virt_to_phys-warnings-fix
+++ a/kernel/perf_counter.c
@@ -2020,7 +2020,7 @@ fail:
 
 static void perf_mmap_free_page(unsigned long addr)
 {
-	struct page *page = virt_to_page(addr);
+	struct page *page = virt_to_page((void *)addr);
 
 	page->mapping = NULL;
 	__free_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test.patch
fix-virt_to_phys-warnings.patch
fix-virt_to_phys-warnings-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
misc-work_on_cpu-acpi-dont-do-local_irq_enable-in-hard-irq.patch
linux-next-temp-hack.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
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

