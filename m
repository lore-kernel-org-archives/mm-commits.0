From: akpm@linux-foundation.org
Subject: - edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 23:01:51 -0700
Message-ID: <200804290601.m3T61pMV004297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221AbYD2GCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Matt_Domsch@dell.com, hpa@zytor.com, rdunlap@xenotime.net, tim.gardner@canonical.com, mm-commits@vger.kernel.org


The patch titled
     edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix
has been removed from the -mm tree.  Its filename was
     edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch

This patch was dropped because it was folded into edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix
+++ a/Documentation/kernel-parameters.txt
@@ -627,7 +627,7 @@ and is between 256 and 4096 characters. 
 	eata=		[HW,SCSI]
 
 	edd=		[EDD]
-			Format: {"off" | "on" | "sk[ipmbr]"}
+			Format: {"off" | "on" | "skip[mbr]"}
 
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
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
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
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

