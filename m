From: akpm@linux-foundation.org
Subject: - blackfin-blackfin-i2c-driver-fix.patch removed from -mm tree
Date: Wed, 07 Mar 2007 12:52:09 -0800
Message-ID: <200703072052.l27KqDYP008341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965652AbXCGUwd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 15:52:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bryan.wu@analog.com, david-b@pacbell.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     blackfin-blackfin-i2c-driver-fix
has been removed from the -mm tree.  Its filename was
     blackfin-blackfin-i2c-driver-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: blackfin-blackfin-i2c-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/Kconfig~blackfin-blackfin-i2c-driver-fix drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~blackfin-blackfin-i2c-driver-fix
+++ a/drivers/i2c/busses/Kconfig
@@ -7,7 +7,7 @@ menu "I2C Hardware Bus support"
 
 config I2C_BFIN_GPIO
 	tristate "Generic Blackfin and HHBF533/561 development board I2C support"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL && BFIN
 	select I2C_ALGOBIT
 	help
 	--
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-ac97-fix-microphone-and-line_in-selection-logic.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
b44-warning-fixes.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
blackfin-blackfin-i2c-driver-fix.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
