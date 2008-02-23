From: akpm@linux-foundation.org
Subject: - git-watchdog-git-rejects.patch removed from -mm tree
Date: Sat, 23 Feb 2008 11:51:25 -0800
Message-ID: <200802231951.m1NJpPiQ012244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761417AbYBWTvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 14:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     git-watchdog-git-rejects
has been removed from the -mm tree.  Its filename was
     git-watchdog-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-watchdog-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig  |    3 ---
 drivers/watchdog/Makefile |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/watchdog/Kconfig~git-watchdog-git-rejects drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~git-watchdog-git-rejects
+++ a/drivers/watchdog/Kconfig
@@ -405,8 +405,6 @@ config IT8712F_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called it8712f_wdt.
 
-<<<<<<< HEAD:drivers/watchdog/Kconfig
-=======
 config HP_WATCHDOG
 	tristate "HP Proliant iLO 2 Hardware Watchdog Timer"
 	depends on X86
@@ -419,7 +417,6 @@ config HP_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called hpwdt.
 
->>>>>>> FETCH_HEAD:drivers/watchdog/Kconfig
 config SC1200_WDT
 	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
 	depends on X86
diff -puN drivers/watchdog/Makefile~git-watchdog-git-rejects drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~git-watchdog-git-rejects
+++ a/drivers/watchdog/Makefile
@@ -69,11 +69,8 @@ obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
-<<<<<<< HEAD:drivers/watchdog/Makefile
-=======
 CFLAGS_hpwdt.o += -O
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
->>>>>>> FETCH_HEAD:drivers/watchdog/Makefile
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
 obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
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
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-watchdog-git-rejects.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
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
