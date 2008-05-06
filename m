From: akpm@linux-foundation.org
Subject: + arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch added to -mm tree
Date: Tue, 06 May 2008 11:47:21 -0700
Message-ID: <200805061847.m46IlLaK021729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246AbYEFSr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, matthias@kaehlcke.net, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix
has been added to the -mm tree.  Its filename is
     arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch

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
Subject: arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap1/board-nokia770.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-omap1/board-nokia770.c~arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix arch/arm/mach-omap1/board-nokia770.c
--- a/arch/arm/mach-omap1/board-nokia770.c~arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix
+++ a/arch/arm/mach-omap1/board-nokia770.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/clk.h>
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
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
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

