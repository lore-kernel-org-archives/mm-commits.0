From: akpm@linux-foundation.org
Subject: - mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch removed from -mm tree
Date: Mon, 20 Oct 2008 14:32:12 -0700
Message-ID: <200810202132.m9KLWCV0021080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbYJTVcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 17:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: drivers/mfd/wm8350-core.c doesn't work on x86
has been removed from the -mm tree.  Its filename was
     mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: drivers/mfd/wm8350-core.c doesn't work on x86
From: Andrew Morton <akpm@linux-foundation.org>

drivers/mfd/wm8350-core.c: In function 'wm8350_device_init':
drivers/mfd/wm8350-core.c:1220: error: 'NO_IRQ' undeclared (first use in this function)
drivers/mfd/wm8350-core.c:1220: error: (Each undeclared identifier is reported only once
drivers/mfd/wm8350-core.c:1220: error: for each function it appears in.)

Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/Kconfig~mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86 drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86
+++ a/drivers/mfd/Kconfig
@@ -116,6 +116,7 @@ config MFD_WM8350_CONFIG_MODE_3
 
 config MFD_WM8350_I2C
 	tristate "Support Wolfson Microelectronics WM8350 with I2C"
+	depends on !X86
 	select MFD_WM8350
 	depends on I2C
 	help
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

