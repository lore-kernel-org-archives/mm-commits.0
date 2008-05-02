From: akpm@linux-foundation.org
Subject: - power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 02 May 2008 13:41:01 -0700
Message-ID: <200805022041.m42Kf2vG013699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935830AbYEBUln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 16:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cbou@mail.ru, dilinger@debian.org, mm-commits@vger.kernel.org


The patch titled
     power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch

This patch was dropped because it was folded into power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

total: 0 errors, 0 warnings, 13 lines checked

./patches/power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch has no obvious style problems and is ready for submission.

Please run checkpatch prior to sending patches

Cc: Andres Salomon <dilinger@debian.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/power/olpc_battery.c~power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes
+++ a/drivers/power/olpc_battery.c
@@ -404,7 +404,8 @@ static int __init olpc_bat_init(void)
 	 * the latest EC protocol, supported by 0x44 and above.
 	 */
 	if (olpc_platform_info.ecver < 0x44) {
-		printk(KERN_NOTICE "OLPC EC version 0x%02x too old for battery driver.\n", olpc_platform_info.ecver);
+		printk(KERN_NOTICE "OLPC EC version 0x%02x too old for "
+			"battery driver.\n", olpc_platform_info.ecver);
 		return -ENXIO;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
sxc-fix-printk-warnings-on-sparc32.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

