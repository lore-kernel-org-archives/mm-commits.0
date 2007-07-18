From: akpm@linux-foundation.org
Subject: - xen-build-fix.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:26 -0700
Message-ID: <200707181852.l6IIqQt0023676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934293AbXGRSzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     xen build fix
has been removed from the -mm tree.  Its filename was
     xen-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen build fix

From

arch/i386/xen/setup.c: In function 'xen_idle':
arch/i386/xen/setup.c:47: warning: implicit declaration of function 'need_resched'

Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/setup.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/xen/setup.c~xen-build-fix arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c~xen-build-fix
+++ a/arch/i386/xen/setup.c
@@ -6,6 +6,7 @@
 
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/pm.h>
 #include <linux/ioport.h>
 
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
add-sys-kernel-notes-fix.patch
use-build-id-ld-option.patch
acpi-add-reboot-mechanism.patch
acpi-add-reboot-mechanism-fix.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
i386-add-support-for-picopower-irq-router.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-sched-clock-share.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
quicklist-support-for-x86_64.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-o_excl-on-dev-mcelog.patch
x86_64-support-poll-on-dev-mcelog.patch
x86_64-mcelog-tolerant-level-cleanup.patch
x86_64-mce-poll-at-idle_start-and-printk-fix.patch
i386-fix-machine-rebooting.patch
x86_64-pm_trace-support.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
i386-remove-support-for-the-rise-cpu.patch
x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
x86-64-calgary-tighten-up-the-bitmap-locking.patch
x86-64-calgary-fold-in-redundant-functions.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch
kprobes-x86_64-fix-for-mark-ro-data.patch
kprobes-i386-fix-for-mark-ro-data.patch
divorce-config_x86_pae-from-config_highmem64g.patch
i386-minor-nx-handling-adjustment.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
move-functions-declarations-to-header-file.patch
x86_64-during-vm-oom-condition.patch
i386-during-vm-oom-condition.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
x86_64-fix-wrong-comment-regarding-set_fixmap.patch
i386-hpet-check-if-the-counter-works.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-get-mp_bus_to_node-as-early.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
x86_64-add-acpi-reboot-option.patch
x86_64-make-acpi-the-default-reset-option.patch
print-utsname-on-oops-on-all-architectures.patch
print-utsname-on-oops-on-all-architectures-fix.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
