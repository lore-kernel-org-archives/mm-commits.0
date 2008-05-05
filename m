From: akpm@linux-foundation.org
Subject: + git-net-git-rejects.patch added to -mm tree
Date: Mon, 05 May 2008 12:05:40 -0700
Message-ID: <200805051905.m45J5eG7032280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852AbYEETGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:06:10 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m45J5ep2014295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 5 May 2008 12:05:41 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-net-git-rejects
has been added to the -mm tree.  Its filename is
     git-net-git-rejects.patch

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
Subject: git-net-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/nsc-ircc.c   |    3 ---
 drivers/net/irda/smsc-ircc2.c |   11 -----------
 2 files changed, 14 deletions(-)

diff -puN drivers/net/irda/nsc-ircc.c~git-net-git-rejects drivers/net/irda/nsc-ircc.c
--- a/drivers/net/irda/nsc-ircc.c~git-net-git-rejects
+++ a/drivers/net/irda/nsc-ircc.c
@@ -100,12 +100,9 @@ static int nsc_ircc_probe_39x(nsc_chip_t
 static int nsc_ircc_init_108(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_338(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_39x(nsc_chip_t *chip, chipio_t *info);
-<<<<<<< HEAD:drivers/net/irda/nsc-ircc.c
-=======
 #ifdef CONFIG_PNP
 static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id);
 #endif
->>>>>>> FETCH_HEAD:drivers/net/irda/nsc-ircc.c
 
 /* These are the known NSC chips */
 static nsc_chip_t chips[] = {
diff -puN drivers/net/irda/smsc-ircc2.c~git-net-git-rejects drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~git-net-git-rejects
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -382,12 +382,9 @@ static const struct pnp_device_id smsc_i
 };
 MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_table);
 
-<<<<<<< HEAD:drivers/net/irda/smsc-ircc2.c
-=======
 static int pnp_driver_registered;
 
 #ifdef CONFIG_PNP
->>>>>>> FETCH_HEAD:drivers/net/irda/smsc-ircc2.c
 static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 				      const struct pnp_device_id *dev_id)
 {
@@ -414,17 +411,9 @@ static struct pnp_driver smsc_ircc_pnp_d
 	.id_table	= smsc_ircc_pnp_table,
 	.probe		= smsc_ircc_pnp_probe,
 };
-<<<<<<< HEAD:drivers/net/irda/smsc-ircc2.c
-
-#else
-static struct pnp_driver smsc_ircc_pnp_driver;
-#endif
-
-=======
 #else /* CONFIG_PNP */
 static struct pnp_driver smsc_ircc_pnp_driver;
 #endif
->>>>>>> FETCH_HEAD:drivers/net/irda/smsc-ircc2.c
 
 /*******************************************************************************
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
sxc-fix-printk-warnings-on-sparc32.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
git-net-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
git-unionfs.patch
git-unionfs-fixup.patch
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

