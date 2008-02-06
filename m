From: akpm@linux-foundation.org
Subject: - rtc-at91sam9-rtc-support-rtt-and-or-rtc-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:30:23 -0800
Message-ID: <200802060730.m167U4cg031825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758899AbYBFHbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:31:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, linux@maxim.org.za, murpme@gmail.com, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     rtc: at91sam9 RTC support (RTT and/or RTC) (fix)
has been removed from the -mm tree.  Its filename was
     rtc-at91sam9-rtc-support-rtt-and-or-rtc-fix.patch

This patch was dropped because it was folded into rtc-at91sam9-rtc-support-rtt-and-or-rtc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: at91sam9 RTC support (RTT and/or RTC) (fix)
From: David Brownell <david-b@pacbell.net>

Fix goofage in rtc-at91sam9 ... unclear why this didn't fail before.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Michel Benoit <murpme@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-rtc-support-rtt-and-or-rtc-fix drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-rtc-support-rtt-and-or-rtc-fix
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -504,7 +504,7 @@ static int __init at91_rtc_init(void)
 			NULL, at91_rtc_match);
 	if (!rtc)
 		platform_driver_unregister(&at91_rtc_driver);
-	return rtc ? -ENODEV : 0;
+	return rtc ? 0 : -ENODEV;
 }
 module_init(at91_rtc_init);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
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
