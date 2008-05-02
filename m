From: akpm@linux-foundation.org
Subject: - aic79xx_core-remove-ascii-art.patch removed from -mm tree
Date: Fri, 02 May 2008 14:16:51 -0700
Message-ID: <200805022116.m42LGprc015383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759252AbYEBVQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 17:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     aic79xx_core: remove ascii art
has been removed from the -mm tree.  Its filename was
     aic79xx_core-remove-ascii-art.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aic79xx_core: remove ascii art
From: Andrew Morton <akpm@linux-foundation.org>

Those '<<<<<<<' lines keep on emitting false-positives when I'm grepping for
git conflicts.  Replace them with '='.

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~aic79xx_core-remove-ascii-art drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~aic79xx_core-remove-ascii-art
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9745,7 +9745,7 @@ ahd_dump_card_state(struct ahd_softc *ah
 	}
 	saved_modes = ahd_save_modes(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-	printf(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n"
+	printf("================== Dump Card State Begins =================\n"
 	       "%s: Dumping Card State at program address 0x%x Mode 0x%x\n",
 	       ahd_name(ahd), 
 	       ahd_inw(ahd, CURADDR),
@@ -9981,7 +9981,7 @@ ahd_dump_card_state(struct ahd_softc *ah
 		ahd_outb(ahd, STACK, ahd->saved_stack[i] & 0xFF);
 		ahd_outb(ahd, STACK, (ahd->saved_stack[i] >> 8) & 0xFF);
 	}
-	printf("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
+	printf("\n================= Dump Card State Ends ==================\n");
 	ahd_restore_modes(ahd, saved_modes);
 	if (paused == 0)
 		ahd_unpause(ahd);
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

