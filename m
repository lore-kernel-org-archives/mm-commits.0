From: akpm@linux-foundation.org
Subject: - cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:40:10 -0700
Message-ID: <200804290540.m3T5eAET003472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbYD2FqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, daniel@hozac.com, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits


The patch titled
     cgroups-implement-device-whitelist-v6-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch

This patch was dropped because it was folded into cgroups-implement-device-whitelist-v6.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-implement-device-whitelist-v6-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
#153: FILE: security/device_cgroup.c:11:
+#include <asm/uaccess.h>

ERROR: spaces required around that '=' (ctx:VxV)
#609: FILE: security/device_cgroup.c:467:
+			count=3;
 			     ^

total: 1 errors, 1 warnings, 669 lines checked

./patches/cgroups-implement-device-whitelist-v6.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daniel Hokka Zakrisson <daniel@hozac.com>
Cc: James Morris <jmorris@namei.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/device_cgroup.c~cgroups-implement-device-whitelist-v6-checkpatch-fixes security/device_cgroup.c
--- a/security/device_cgroup.c~cgroups-implement-device-whitelist-v6-checkpatch-fixes
+++ a/security/device_cgroup.c
@@ -8,7 +8,7 @@
 #include <linux/cgroup.h>
 #include <linux/ctype.h>
 #include <linux/list.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define ACC_MKNOD 1
 #define ACC_READ  2
@@ -464,7 +464,7 @@ static ssize_t devcgroup_access_write(st
 			break;
 		case '\n':
 		case '\0':
-			count=3;
+			count = 3;
 			break;
 		default:
 			retval = -EINVAL;
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
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
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

