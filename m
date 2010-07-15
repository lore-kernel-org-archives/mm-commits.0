From: akpm@linux-foundation.org
Subject: + parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch added to -mm tree
Date: Thu, 15 Jul 2010 13:05:15 -0700
Message-ID: <201007152005.o6FK5FWs016456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934613Ab0GOUFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 16:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lee.jones@canonical.com, rmk@arm.linux.org.uk


The patch titled
     parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix
has been added to the -mm tree.  Its filename is
     parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment layout

Cc: Lee Jones <lee.jones@canonical.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/parport.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/arm/include/asm/parport.h~parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix arch/arm/include/asm/parport.h
--- a/arch/arm/include/asm/parport.h~parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix
+++ a/arch/arm/include/asm/parport.h
@@ -9,12 +9,13 @@
 #ifndef __ASMARM_PARPORT_H
 #define __ASMARM_PARPORT_H
 
-static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
+static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
 {
-/* parport_pc_find_isa_ports uses direct register addresses which are
- * only correct on x86 architectures. This may have undesirable
- * consequences (including segfaults) when used on other architectures.
- */
+	/*
+	 * parport_pc_find_isa_ports() uses direct register addresses which are
+	 * only correct on x86 architectures. This may have undesirable
+	 * consequences (including segfaults) when used on other architectures.
+	 */
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
x86-numa-fix-boot-without-ram-on-node0-again-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-driver-core-remove-config_sysfs_deprecated.patch
module-fix-crash-in-get_ksymbol-when-oopsing-in-module-init.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
acpi-fix-bogus-preemption-logic-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path-v2-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
serial-mmio32-support-for-8250_earlyc-fix-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

