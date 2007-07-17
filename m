From: akpm@linux-foundation.org
Subject: - add-argv_split-fix.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:18:28 -0700
Message-ID: <200707170818.l6H8ISMq007220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbXGQISj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeremy@goop.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add-argv_split-fix
has been removed from the -mm tree.  Its filename was
     add-argv_split-fix.patch

This patch was dropped because sent to Jeremy, lost interest in it

------------------------------------------------------
Subject: add-argv_split-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/argv_split.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN lib/argv_split.c~add-argv_split-fix lib/argv_split.c
--- a/lib/argv_split.c~add-argv_split-fix
+++ a/lib/argv_split.c
@@ -41,7 +41,6 @@ static int count_argc(const char *str)
 
 /**
  * argv_free - free an argv
- *
  * @argv - the argument vector to be freed
  *
  * Frees an argv and the strings it points to.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
i386-speedup-touch_nmi_watchdog.patch
x86_64-speedup-touch_nmi_watchdog.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support.patch
spi-master-driver-for-xilinx-virtex.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-driver-for-ds1216-chips-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
