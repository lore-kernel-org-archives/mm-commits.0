From: akpm@linux-foundation.org
Subject: - sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 29 Jul 2008 22:26:05 -0700
Message-ID: <200807300526.m6U5Q5tc009052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbYG3F1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 01:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, andi@firstfloor.org, drzeus-list@drzeus.cx, gregkh@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes.patch

This patch was dropped because it was folded into sched-make-scheduler-sysfs-attributes-sysdev-class-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#40: FILE: kernel/sched.c:7673:
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, $

ERROR: code indent should use tabs where possible
#42: FILE: kernel/sched.c:7675:
+^I^I         sched_mc_power_savings_store);$

ERROR: trailing whitespace
#61: FILE: kernel/sched.c:7689:
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, $

total: 3 errors, 0 warnings, 45 lines checked

./patches/sched-make-scheduler-sysfs-attributes-sysdev-class-devices.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes kernel/sched.c
--- a/kernel/sched.c~sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes
+++ a/kernel/sched.c
@@ -7681,9 +7681,9 @@ static ssize_t sched_mc_power_savings_st
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, 
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
 			 sched_mc_power_savings_show,
-		         sched_mc_power_savings_store);
+			 sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -7697,7 +7697,7 @@ static ssize_t sched_smt_power_savings_s
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, 
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
 		   sched_smt_power_savings_show,
 		   sched_smt_power_savings_store);
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

connector-add-a-blackboard-user-to-connector.patch
sched-make-scheduler-sysfs-attributes-sysdev-class-devices.patch
sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gru-driver-v3-fixes-to-resolve-code-review-comments-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
drivers-mtd-nand-fsl_elbc_nandc-fix-printk-warning.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
w1-feature-enable-hardware-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

