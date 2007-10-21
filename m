From: akpm@linux-foundation.org
Subject: - memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:49:17 -0700
Message-ID: <200710212349.l9LNnHOf000771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbXJUX4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rient


The patch titled
     memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2
has been removed from the -mm tree.  Its filename was
     memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch

This patch was dropped because it was folded into memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch

------------------------------------------------------
Subject: memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

sparc32:

In file included from include/linux/mm.h:38,
                 from include/linux/memcontrol.h:23,
                 from include/linux/swap.h:9,
                 from include/linux/suspend.h:7,
                 from init/do_mounts.c:6:
include/asm/pgtable.h:344: warning: parameter names (without types) in function declaration
include/asm/pgtable.h:345: warning: parameter names (without types) in function declaration
include/asm/pgtable.h:346: error: expected '=', ',', ';', 'asm' or '__attribute__' before '___f___swp_entry'

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2
+++ a/include/linux/memcontrol.h
@@ -20,10 +20,10 @@
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
 
-#include <linux/mm.h>
-
 struct mem_cgroup;
 struct page_cgroup;
+struct page;
+struct mm_struct;
 
 #ifdef CONFIG_CGROUP_MEM_CONT
 
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
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
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
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
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
