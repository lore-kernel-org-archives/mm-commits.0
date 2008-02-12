From: akpm@linux-foundation.org
Subject: + sunprc-fix-printk-format-warning-checkpatch-fixes.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:24:53 -0800
Message-ID: <200802122324.m1CNOrfe028299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYBLXZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:25:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rolandd@cisco.com


The patch titled
     sunprc-fix-printk-format-warning-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sunprc-fix-printk-format-warning-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunprc-fix-printk-format-warning-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#20: FILE: net/sunrpc/xprtrdma/svc_rdma_sendto.c:162:
+		rmr, (unsigned long long) to, xdr_off, write_len, xdr_sge, sge_count);

total: 0 errors, 1 warnings, 8 lines checked

./patches/sunprc-fix-printk-format-warning.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/xprtrdma/svc_rdma_sendto.c~sunprc-fix-printk-format-warning-checkpatch-fixes net/sunrpc/xprtrdma/svc_rdma_sendto.c
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c~sunprc-fix-printk-format-warning-checkpatch-fixes
+++ a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -159,7 +159,8 @@ static int send_write(struct svcxprt_rdm
 	BUG_ON(sge_count >= 32);
 	dprintk("svcrdma: RDMA_WRITE rmr=%x, to=%llx, xdr_off=%d, "
 		"write_len=%d, xdr_sge=%p, sge_count=%d\n",
-		rmr, (unsigned long long) to, xdr_off, write_len, xdr_sge, sge_count);
+		rmr, (unsigned long long) to, xdr_off, write_len,
+		xdr_sge, sge_count);
 
 	ctxt = svc_rdma_get_context(xprt);
 	ctxt->count = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
softlockup-workaround.patch
revert-proc-fix-the-threaded-proc-self.patch
memstick-initial-commit-for-sony-memorystick-support.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-mmc.patch
typhoon-section-fix.patch
natsemi-section-fix.patch
bnx2x-section-fix.patch
bnx2c-section-fix.patch
via-velocity-section-fix.patch
starfire-secton-fix.patch
pppol2tp-fix-printk-warnings.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
mempolicy-silently-restrict-nodemask-to-allowed-nodes-v3.patch
sunprc-fix-printk-format-warning-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
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
