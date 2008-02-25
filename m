From: akpm@linux-foundation.org
Subject: + misc-phantom-add-compat-ioctl-checkpatch-fixes.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:22:17 -0800
Message-ID: <200802251823.m1PIN9wY012921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623AbYBYSXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jirislaby@gmail.com


The patch titled
     misc-phantom-add-compat-ioctl-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     misc-phantom-add-compat-ioctl-checkpatch-fixes.patch

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
Subject: misc-phantom-add-compat-ioctl-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: no space between function name and open parenthesis '('
#101: FILE: include/linux/phantom.h:38:
+#define PHN_SETREG		_IOW (PH_IOC_MAGIC, 6, struct phm_reg)

WARNING: no space between function name and open parenthesis '('
#103: FILE: include/linux/phantom.h:40:
+#define PHN_SETREGS		_IOW (PH_IOC_MAGIC, 8, struct phm_regs)

total: 0 errors, 2 warnings, 78 lines checked

./patches/misc-phantom-add-compat-ioctl.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/phantom.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/phantom.h~misc-phantom-add-compat-ioctl-checkpatch-fixes include/linux/phantom.h
--- a/include/linux/phantom.h~misc-phantom-add-compat-ioctl-checkpatch-fixes
+++ a/include/linux/phantom.h
@@ -35,9 +35,9 @@ struct phm_regs {
  * libphantom) */
 #define PHN_NOT_OH		_IO  (PH_IOC_MAGIC, 4)
 #define PHN_GETREG		_IOWR(PH_IOC_MAGIC, 5, struct phm_reg)
-#define PHN_SETREG		_IOW (PH_IOC_MAGIC, 6, struct phm_reg)
+#define PHN_SETREG		_IOW(PH_IOC_MAGIC, 6, struct phm_reg)
 #define PHN_GETREGS		_IOWR(PH_IOC_MAGIC, 7, struct phm_regs)
-#define PHN_SETREGS		_IOW (PH_IOC_MAGIC, 8, struct phm_regs)
+#define PHN_SETREGS		_IOW(PH_IOC_MAGIC, 8, struct phm_regs)
 
 #define PHN_CONTROL		0x6     /* control byte in iaddr space */
 #define PHN_CTL_AMP		0x1     /*   switch after torques change */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fix-rejects.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
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
