From: akpm@linux-foundation.org
Subject: - fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:59:56 -0700
Message-ID: <200710160459.l9G4xuZP009930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928AbXJPFAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 01:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev-fb_create_modedb-non-static-int-first-=-1-fix
has been removed from the -mm tree.  Its filename was
     fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch

This patch was dropped because it was folded into fbdev-fb_create_modedb-non-static-int-first-=-1.patch

------------------------------------------------------
Subject: fbdev-fb_create_modedb-non-static-int-first-=-1-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/video/fbmon.c~fbdev-fb_create_modedb-non-static-int-first-=-1-fix drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbdev-fb_create_modedb-non-static-int-first-=-1-fix
+++ a/drivers/video/fbmon.c
@@ -593,8 +593,6 @@ static struct fb_videomode *fb_create_mo
 	unsigned char *block;
 	int num = 0, i, first = 1;
 
-;
-
 	mode = kzalloc(50 * sizeof(struct fb_videomode), GFP_KERNEL);
 	if (mode == NULL)
 		return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
nfs-convert-to-new-aops.patch
fs-restore-nobh.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
categorize-gfp-flags.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support.patch
mm-mempolicyc-cleanups.patch
uml-fix-stub-address-calculations.patch
uml-arch-um-drivers-formatting.patch
ecryptfs-printk-warning-fixes.patch
rtc-cmos-probe-cleanup.patch
tdfxfb-mtrr-support.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
fbcon-logo-disable-logo-at-boot-fix.patch
fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes.patch
md-software-raid-autodetect-dev-list-not-array.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
pnp-use-dev_info-dev_err-etc-in-core-fix.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch
