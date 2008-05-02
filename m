From: akpm@linux-foundation.org
Subject: - watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 02 May 2008 13:46:52 -0700
Message-ID: <200805022046.m42Kkq0R014080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936735AbYEBUrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 16:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, g.chen@freescale.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#172: FILE: drivers/watchdog/booke_wdt.c:178:
+		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "

total: 0 errors, 1 warnings, 155 lines checked

./patches/watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Chen Gong <g.chen@freescale.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/booke_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes drivers/watchdog/booke_wdt.c
--- a/drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes
+++ a/drivers/watchdog/booke_wdt.c
@@ -175,7 +175,7 @@ static int __init booke_wdt_init(void)
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
 				"(wdt_period=%d)\n", booke_wdt_period);
 		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
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
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
aic79xx_core-remove-ascii-art.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
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

