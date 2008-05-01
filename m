From: akpm@linux-foundation.org
Subject: - pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 01 May 2008 02:49:35 -0700
Message-ID: <200805010949.m419nZwJ031752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757599AbYEAJuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bjorn.helgaas@hp.com, joe@perches.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     pnp-fix-printk-format-warnings-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into pnp-fix-printk-format-warnings.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp-fix-printk-format-warnings-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#28: FILE: drivers/pnp/pnpbios/rsparser.c:594:
+	dev_dbg(&dev->dev, "  encode irq %llu\n", (unsigned long long)res->start);

WARNING: line over 80 characters
#37: FILE: drivers/pnp/pnpbios/rsparser.c:605:
+	dev_dbg(&dev->dev, "  encode dma %llu\n", (unsigned long long)res->start);

total: 0 errors, 2 warnings, 16 lines checked

./patches/pnp-fix-printk-format-warnings-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/rsparser.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings-fix-checkpatch-fixes drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-fix-printk-format-warnings-fix-checkpatch-fixes
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -591,7 +591,8 @@ static void pnpbios_encode_irq(struct pn
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq %llu\n", (unsigned long long)res->start);
+	dev_dbg(&dev->dev, "  encode irq %llu\n",
+		(unsigned long long)res->start);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
@@ -602,7 +603,8 @@ static void pnpbios_encode_dma(struct pn
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma %llu\n", (unsigned long long)res->start);
+	dev_dbg(&dev->dev, "  encode dma %llu\n",
+		(unsigned long long)res->start);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
pnp-fix-printk-format-warnings.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
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

