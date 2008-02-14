From: akpm@linux-foundation.org
Subject: - ipmi-convert-locked-counters-to-atomics-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 13 Feb 2008 16:29:05 -0800
Message-ID: <200802140029.m1E0T5bO022235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935197AbYBNAb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:31:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cminyard@mvista.com, kbaidarov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi-convert-locked-counters-to-atomics-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipmi-convert-locked-counters-to-atomics-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi-convert-locked-counters-to-atomics-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: open brace '{' following struct go on the same line
#29: FILE: drivers/char/ipmi/ipmi_msghandler.c:189:
+struct ipmi_stats
+{

ERROR: use tabs not spaces
#47: FILE: drivers/char/ipmi/ipmi_msghandler.c:207:
+           incremented. */$

ERROR: use tabs not spaces
#51: FILE: drivers/char/ipmi/ipmi_msghandler.c:211:
+           *not* included in the above count (they are expected to$

ERROR: use tabs not spaces
#52: FILE: drivers/char/ipmi/ipmi_msghandler.c:212:
+           time out). */$

ERROR: use tabs not spaces
#72: FILE: drivers/char/ipmi/ipmi_msghandler.c:232:
+           incremented. */$

total: 5 errors, 0 warnings, 723 lines checked

./patches/ipmi-convert-locked-counters-to-atomics.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Corey Minyard <cminyard@mvista.com>
Cc: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-locked-counters-to-atomics-checkpatch-fixes drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-locked-counters-to-atomics-checkpatch-fixes
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -204,12 +204,12 @@ struct ipmi_stats
 	/* Each retransmit increments this count. */
 	atomic_t retransmitted_ipmb_commands;
 	/* When a message times out (runs out of retransmits) this is
-           incremented. */
+	   incremented. */
 	atomic_t timed_out_ipmb_commands;
 
 	/* This is like above, but for broadcasts.  Broadcasts are
-           *not* included in the above count (they are expected to
-           time out). */
+	   *not* included in the above count (they are expected to
+	   time out). */
 	atomic_t timed_out_ipmb_broadcasts;
 
 	/* Responses I have sent to the IPMB bus. */
@@ -229,7 +229,7 @@ struct ipmi_stats
 	/* Each retransmit increments this count. */
 	atomic_t retransmitted_lan_commands;
 	/* When a message times out (runs out of retransmits) this is
-           incremented. */
+	   incremented. */
 	atomic_t timed_out_lan_commands;
 
 	/* Responses I have sent to the IPMB bus. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

softlockup-workaround.patch
include-linux-remove-all-users-of-fastcall-macro.patch
fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
smack-check-for-struct-socket-with-null-sk.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
fix-ide-mm-ide-remove-broken-dangerous-ide-unregister-scan-hwif-ioctls.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-conflicts.patch
git-sparc64.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-conflicts.patch
git-x86.patch
git-x86-vs-git-kvm.patch
git-x86-cpa-build-fix.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-git-conflicts.patch
git-xtensa.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-convert-locked-counters-to-atomics-checkpatch-fixes.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-checkpatch-fixes.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
