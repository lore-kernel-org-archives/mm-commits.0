From: akpm@linux-foundation.org
Subject: + git-watchdog-git-rejects.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:11:35 -0500
Message-ID: <200802150214.m1F2Esxh014772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276AbYBOCP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, wim@iguana.be


The patch titled
     git-watchdog-git-rejects
has been added to the -mm tree.  Its filename is
     git-watchdog-git-rejects.patch

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
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
introduce-path_put.patch
one-less-parameter-to-__d_path.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
d_path-make-d_path-use-a-struct-path.patch
softlockup-workaround.patch
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
git-md-accel.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
scsi-fix-data-corruption-caused-by-ses-checkpatch-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-sparc64.patch
git-unionfs.patch
git-unionfs-fixup.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
git-x86-vs-git-kvm.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-git-rejects.patch
git-xtensa.patch
add-rcu_assign_index-if-ever-needed-fix.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
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
