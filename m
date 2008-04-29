From: akpm@linux-foundation.org
Subject: - edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 23:05:28 -0700
Message-ID: <200804290605.m3T65SSB004427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbYD2GFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, ptyser@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch

This patch was dropped because it was folded into edac-add-e752x-parameter-for-sysbus_parity-selection.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#91: FILE: drivers/edac/e752x_edac.c:1326:
+                " 1=enable system bus parity checking, default=auto-detect");$

total: 1 errors, 0 warnings, 61 lines checked

./patches/edac-add-e752x-parameter-for-sysbus_parity-selection.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/e752x_edac.c~edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes
+++ a/drivers/edac/e752x_edac.c
@@ -1328,4 +1328,4 @@ MODULE_PARM_DESC(edac_op_state, "EDAC Er
 
 module_param(sysbus_parity, int, 0444);
 MODULE_PARM_DESC(sysbus_parity, "0=disable system bus parity checking,"
-                " 1=enable system bus parity checking, default=auto-detect");
+		" 1=enable system bus parity checking, default=auto-detect");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroups-implement-device-whitelist-v6.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
memcgroup-implement-failcounter-reset.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-add-definitions-of-ushort_max-and-others.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
ipmi-run-to-completion-fixes.patch
ipmi-style-fixes-in-the-system-interface-code.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
idr-create-idr_layer_cache-at-boot-time.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
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
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

