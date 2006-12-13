From: akpm@osdl.org
Subject: - updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:17 -0800
Message-ID: <200612132249.kBDMnHDv023144@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbWLMWwe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:52:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/i386/kernel/apic.c: make a function static
has been removed from the -mm tree.  Its filename was
     updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: arch/i386/kernel/apic.c: make a function static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the needlessly global local_apic_timer_interrupt()
static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/apic.c~updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static
+++ a/arch/i386/kernel/apic.c
@@ -451,7 +451,7 @@ EXPORT_SYMBOL(switch_ipi_to_APIC_timer);
 /*
  * The guts of the apic timer interrupt
  */
-fastcall void local_apic_timer_interrupt(struct pt_regs *regs)
+static fastcall void local_apic_timer_interrupt(struct pt_regs *regs)
 {
 	int cpu = smp_processor_id();
 	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
one-more-export_unused_symbol-removal.patch
remove-the-broken-blk_dev_swim_iop-driver.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
acpi-make-code-static.patch
git-alsa.patch
proper-prototype-for-drivers-base-initcdriver_init.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

