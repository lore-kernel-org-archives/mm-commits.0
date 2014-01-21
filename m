From: akpm@linux-foundation.org
Subject: + maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch added to -mm tree
Date: Tue, 21 Jan 2014 11:48:16 -0800
Message-ID: <52decf00.LAbphJY7AQMZ8Q1L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaAUTsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:48:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:48:16 -0800


The patch titled
     Subject: MAINTAINERS: remove unnecessary EXYNOS DP DRIVER F: pattern
has been added to the -mm tree.  Its filename is
     maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: MAINTAINERS: remove unnecessary EXYNOS DP DRIVER F: pattern

Remove unnecessary pattern for Exynos DP header from MAINTAINERS file. 
After f9b1e01 ("video: exynos_dp: remove non-DT support for Exynos Display
Port"), 'exynos_dp.h' has not been used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unnecessary-exynos-dp-driver-f-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unnecessary-exynos-dp-driver-f-pattern
+++ a/MAINTAINERS
@@ -3350,7 +3350,6 @@ M:	Jingoo Han <jg1.han@samsung.com>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/exynos/exynos_dp*
-F:	include/video/exynos_dp*
 
 EXYNOS MIPI DISPLAY DRIVERS
 M:	Inki Dae <inki.dae@samsung.com>
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch
backlight-jornada720-use-devm_backlight_device_register.patch
backlight-hp680_bl-use-devm_backlight_device_register.patch
backlight-omap1-use-devm_backlight_device_register.patch
backlight-ot200_bl-use-devm_backlight_device_register.patch
backlight-tosa-use-devm_backlight_device_register.patch
backlight-jornada720-use-devm_lcd_device_register.patch
backlight-l4f00242t03-use-devm_lcd_device_register.patch
backlight-tosa-use-devm_lcd_device_register.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch
backlight-lp855x-remove-unnecessary-parentheses.patch
backlight-lp8788-remove-unnecessary-parentheses.patch
drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch
rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

