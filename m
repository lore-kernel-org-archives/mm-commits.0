From: akpm@linux-foundation.org
Subject: - x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch removed from -mm tree
Date: Thu, 01 May 2008 02:52:23 -0700
Message-ID: <200805010952.m419qN0R031850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771AbYEAJwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:52:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dilinger@debian.org, dilinger@queued.net, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup
has been removed from the -mm tree.  Its filename was
     x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch

This patch was dropped because it was folded into x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andres Salomon <dilinger@debian.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/geode_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/geode_32.c~x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup arch/x86/kernel/geode_32.c
--- a/arch/x86/kernel/geode_32.c~x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup
+++ a/arch/x86/kernel/geode_32.c
@@ -161,10 +161,10 @@ void geode_gpio_setup_event(unsigned int
 }
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
-static int has_vsa2 = -1;
-
 int geode_has_vsa2(void)
 {
+	static int has_vsa2 = -1;
+
 	if (has_vsa2 == -1) {
 		/*
 		 * The VSA has virtual registers that we can query for a
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pnp-fix-printk-format-warnings.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
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
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

