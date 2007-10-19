From: akpm@linux-foundation.org
Subject: - git-acpi-fixup.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:39 -0700
Message-ID: <200710192254.l9JMsd45024552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966804AbXJSXFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ibm-acpi@hmh.eng.br, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     git-acpi-fixup
has been removed from the -mm tree.  Its filename was
     git-acpi-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-acpi-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix git rejects between git-acpi and mainline.

Nuke lots of pointess static-declarations-in-a-header while we're there.

Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/thinkpad_acpi.c |    4 ----
 drivers/misc/thinkpad_acpi.h |    9 ---------
 2 files changed, 13 deletions(-)

diff -puN drivers/misc/thinkpad_acpi.c~git-acpi-fixup drivers/misc/thinkpad_acpi.c
--- a/drivers/misc/thinkpad_acpi.c~git-acpi-fixup
+++ a/drivers/misc/thinkpad_acpi.c
@@ -526,12 +526,8 @@ static char *next_cmd(char **cmds)
  ****************************************************************************/
 
 static struct platform_device *tpacpi_pdev;
-<<<<<<< HEAD:drivers/misc/thinkpad_acpi.c
 static struct device *tpacpi_hwmon;
-=======
 static struct platform_device *tpacpi_sensors_pdev;
-static struct class_device *tpacpi_hwmon;
->>>>>>> FETCH_HEAD:drivers/misc/thinkpad_acpi.c
 static struct input_dev *tpacpi_inputdev;
 static struct mutex tpacpi_inputdev_send_mutex;
 
diff -puN drivers/misc/thinkpad_acpi.h~git-acpi-fixup drivers/misc/thinkpad_acpi.h
--- a/drivers/misc/thinkpad_acpi.h~git-acpi-fixup
+++ a/drivers/misc/thinkpad_acpi.h
@@ -171,15 +171,6 @@ static int parse_strtoul(const char *buf
 			unsigned long *value);
 
 /* Device model */
-static struct platform_device *tpacpi_pdev;
-<<<<<<< HEAD:drivers/misc/thinkpad_acpi.h
-static struct device *tpacpi_hwmon;
-=======
-static struct platform_device *tpacpi_sensors_pdev;
-static struct class_device *tpacpi_hwmon;
->>>>>>> FETCH_HEAD:drivers/misc/thinkpad_acpi.h
-static struct platform_driver tpacpi_pdriver;
-static struct input_dev *tpacpi_inputdev;
 static int tpacpi_create_driver_attributes(struct device_driver *drv);
 static void tpacpi_remove_driver_attributes(struct device_driver *drv);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
git-parisc.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-checkpatch-fixes.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
