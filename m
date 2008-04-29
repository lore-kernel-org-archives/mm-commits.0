From: akpm@linux-foundation.org
Subject: - idr-create-idr_layer_cache-at-boot-time-fix-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 23:04:23 -0700
Message-ID: <200804290604.m3T64Nt5004409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbYD2GEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:04:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr-create-idr_layer_cache-at-boot-time-fix-fix
has been removed from the -mm tree.  Its filename was
     idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

This patch was dropped because it was folded into idr-create-idr_layer_cache-at-boot-time.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr-create-idr_layer_cache-at-boot-time-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

alpha:

In file included from include/linux/ipc_namespace.h:5,
                 from ipc/namespace.c:8:
include/linux/idr.h:118: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'idr_init_cache'

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 idr.c               |    0 
 include/linux/idr.h |    1 +
 2 files changed, 1 insertion(+)

diff -puN include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time-fix-fix include/linux/idr.h
--- a/include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time-fix-fix
+++ a/include/linux/idr.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/init.h>
 
 #if BITS_PER_LONG == 32
 # define IDR_BITS 5
diff -puN init/main.c~idr-create-idr_layer_cache-at-boot-time-fix-fix init/main.c
diff -puN lib/idr.c~idr-create-idr_layer_cache-at-boot-time-fix-fix lib/idr.c
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

