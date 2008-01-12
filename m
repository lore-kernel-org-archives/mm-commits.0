From: akpm@linux-foundation.org
Subject: - generic-gpio-gpio_chip-support-fix.patch removed from -mm tree
Date: Fri, 11 Jan 2008 18:12:49 -0800
Message-ID: <200801120212.m0C2CnmB009301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278AbYALCNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:13:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     minor gpiolib tweaks
has been removed from the -mm tree.  Its filename was
     generic-gpio-gpio_chip-support-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: minor gpiolib tweaks
From: David Brownell <david-b@pacbell.net>

Minor fixups to the gpiolib code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/gpiolib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/gpiolib.c~generic-gpio-gpio_chip-support-fix lib/gpiolib.c
--- a/lib/gpiolib.c~generic-gpio-gpio_chip-support-fix
+++ a/lib/gpiolib.c
@@ -28,7 +28,7 @@
 #define	extra_checks	0
 #endif
 
-/* gpio_lock protects the table of chips and to gpio_chip->requested.
+/* gpio_lock protects the table of chips and gpio_chip->requested.
  * While any gpio is requested, its gpio_chip is not removable.  It's
  * a raw spinlock to ensure safe access from hardirq contexts, and to
  * shrink bitbang overhead:  per-bit preemption would be very wrong.
@@ -533,6 +533,6 @@ static int __init gpiolib_debugfs_init(v
 				NULL, NULL, &gpiolib_operations);
 	return 0;
 }
-postcore_initcall(gpiolib_debugfs_init);
+subsys_initcall(gpiolib_debugfs_init);
 
 #endif	/* DEBUG_FS */
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-arm.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
git-input.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
remove-obsolete-sys-devices-power-state-docs.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
