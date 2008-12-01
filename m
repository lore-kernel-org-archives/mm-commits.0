From: akpm@linux-foundation.org
Subject: - pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:29:49 -0800
Message-ID: <200812012229.mB1MTnb2018149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbYLAWae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:30:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, mjg59@srcf.ucam.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch

This patch was dropped because it was folded into pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#48: FILE: drivers/pci/hotplug/pciehp_core.c:64:
+MODULE_PARM_DESC(pciehp_passive, "Listen for pciehp events, even if _OSC and OSHP are missing");

ERROR: code indent should use tabs where possible
#59: FILE: drivers/pci/hotplug/pciehp_core.c:94:
+  ^I.get_max_bus_speed =^Iget_max_bus_speed,$

ERROR: code indent should use tabs where possible
#60: FILE: drivers/pci/hotplug/pciehp_core.c:95:
+  ^I.get_cur_bus_speed =^Iget_cur_bus_speed,$

total: 2 errors, 1 warnings, 68 lines checked

./patches/pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/hotplug/pciehp_core.c~pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -91,8 +91,8 @@ static struct hotplug_slot_ops pciehp_ho
 static struct hotplug_slot_ops pciehp_passive_hotplug_slot_ops = {
 	.owner =		THIS_MODULE,
 	.get_adapter_status =	get_adapter_status,
-  	.get_max_bus_speed =	get_max_bus_speed,
-  	.get_cur_bus_speed =	get_cur_bus_speed,
+	.get_max_bus_speed =	get_max_bus_speed,
+	.get_cur_bus_speed =	get_cur_bus_speed,
 };
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-introduce-resource-usage-limits.patch
ntfs-dont-fool-kernel-doc.patch
drivers-gpu-drm-i915-i915_irqc-fix-warning.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
drivers-hwmon-f71882fgc-make-dev_attr_name-static.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

