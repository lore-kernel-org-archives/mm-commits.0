From: akpm@linux-foundation.org
Subject: + gpiolib-support-for-the-pxa-architecture-kconfig-fix.patch added to -mm tree
Date: Mon, 04 Feb 2008 23:26:50 -0800
Message-ID: <200802050726.m157QV1N009526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbYBEH1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 02:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     gpiolib support for the PXA architecture: Kconfig fix
has been added to the -mm tree.  Its filename is
     gpiolib-support-for-the-pxa-architecture-kconfig-fix.patch

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
Subject: gpiolib support for the PXA architecture: Kconfig fix
From: David Brownell <david-b@pacbell.net>

The merge of Orion made the Kconfig change apply in the wrong place, so
this is needed to fix build breakage.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~gpiolib-support-for-the-pxa-architecture-kconfig-fix arch/arm/Kconfig
--- a/arch/arm/Kconfig~gpiolib-support-for-the-pxa-architecture-kconfig-fix
+++ a/arch/arm/Kconfig
@@ -372,7 +372,6 @@ config ARCH_ORION
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
-	select HAVE_GPIO_LIB
 	help
 	  Support for Marvell Orion System on Chip family.
 
@@ -386,6 +385,7 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
+	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
pcmcia-stop-updating-dev-powerpower_state.patch
gpiolib-support-for-the-pxa-architecture-kconfig-fix.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-input.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
spi-remove-more-dev-powerpower_state-usage.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
rtc-update-documentation-wrt-irq_set_freq.patch
rtc-cleanup-example-code.patch
rtc-remove-more-dev-powerpower_state-usage.patch
rtc-at91sam9-rtc-support-rtt-and-or-rtc.patch
rtc-at91sam9-rtc-support-rtt-and-or-rtc-fix.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
