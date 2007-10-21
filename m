From: akpm@linux-foundation.org
Subject: - pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:50:36 -0700
Message-ID: <200710212350.l9LNoafn000870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbXJUXve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, abelay@novell.com, arjan@infradead.org, lenb@kernel.org, mgross@linux.intel.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch

This patch was dropped because it was folded into pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch

------------------------------------------------------
Subject: pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#37: FILE: drivers/cpuidle/cpuidle.c:271:
$

WARNING: line over 80 characters
#61: FILE: drivers/cpuidle/governors/menu.c:51:
+		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Adam Belay <abelay@novell.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Mark Gross <mgross@linux.intel.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: mark gross <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/cpuidle.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes
+++ a/drivers/cpuidle/cpuidle.c
@@ -268,7 +268,7 @@ static struct notifier_block cpuidle_lat
 
 static inline void latency_notifier_init(struct notifier_block *n)
 {
-        pm_qos_add_notifier(PM_QOS_CPU_DMA_LATENCY, n);
+	pm_qos_add_notifier(PM_QOS_CPU_DMA_LATENCY, n);
 }
 
 #else /* CONFIG_SMP */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
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
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
fix-x86_64-mm-sched-clock-share.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
