From: akpm@linux-foundation.org
Subject: + maintainers-remove-richard-purdie-as-backlight-maintainer.patch added to -mm tree
Date: Mon, 07 Oct 2013 18:08:14 -0700
Message-ID: <52535afe.IEbdONm33ZpIBeed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3JHBIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 21:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rpurdie@rpsys.net, jg1.han@samsung.com

Subject: + maintainers-remove-richard-purdie-as-backlight-maintainer.patch added to -mm tree
To: jg1.han@samsung.com,rpurdie@rpsys.net
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 18:08:14 -0700


The patch titled
     Subject: MAINTAINERS: remove Richard Purdie as backlight maintainer
has been added to the -mm tree.  Its filename is
     maintainers-remove-richard-purdie-as-backlight-maintainer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-richard-purdie-as-backlight-maintainer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-richard-purdie-as-backlight-maintainer.patch

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
Subject: MAINTAINERS: remove Richard Purdie as backlight maintainer

Remove Richard Purdie as backlight subsystem maintainer,

akpm: Richard is still responsive and is reviewing some of the patches,
but appears to agree that listing him as the maintainer is no longer
appropriate.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    5 +++++
 MAINTAINERS |    1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN CREDITS~maintainers-remove-richard-purdie-as-backlight-maintainer CREDITS
--- a/CREDITS~maintainers-remove-richard-purdie-as-backlight-maintainer
+++ a/CREDITS
@@ -2895,6 +2895,11 @@ S: Framewood Road
 S: Wexham SL3 6PJ
 S: United Kingdom
 
+N: Richard Purdie
+E: rpurdie@rpsys.net
+D: Backlight subsystem maintainer
+S: USA
+
 N: Daniel Quinlan
 E: quinlan@pathname.com
 W: http://www.pathname.com/~quinlan/
diff -puN MAINTAINERS~maintainers-remove-richard-purdie-as-backlight-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-richard-purdie-as-backlight-maintainer
+++ a/MAINTAINERS
@@ -1651,7 +1651,6 @@ S:	Maintained
 F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
-M:	Richard Purdie <rpurdie@rpsys.net>
 M:	Jingoo Han <jg1.han@samsung.com>
 S:	Maintained
 F:	drivers/video/backlight/
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
maintainers-remove-richard-purdie-as-backlight-maintainer.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
backlight-lm3630-potential-null-deref-in-probe.patch
backlight-lm3630-apply-chip-revision-fix.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
backlight-88pm860x_bl-use-devm_backlight_device_register.patch
backlight-aat2870-use-devm_backlight_device_register.patch
backlight-adp5520-use-devm_backlight_device_register.patch
backlight-adp8860-use-devm_backlight_device_register.patch
backlight-adp8870-use-devm_backlight_device_register.patch
backlight-as3711_bl-use-devm_backlight_device_register.patch
backlight-atmel-pwm-bl-use-devm_backlight_device_register.patch
backlight-bd6107-use-devm_backlight_device_register.patch
backlight-da903x_bl-use-devm_backlight_device_register.patch
backlight-da9052_bl-use-devm_backlight_device_register.patch
backlight-ep93xx-use-devm_backlight_device_register.patch
backlight-generic_bl-use-devm_backlight_device_register.patch
backlight-gpio_backlight-use-devm_backlight_device_register.patch
backlight-kb3886_bl-use-devm_backlight_device_register.patch
backlight-lm3533_bl-use-devm_backlight_device_register.patch
backlight-lp855x-use-devm_backlight_device_register.patch
backlight-lv5207lp-use-devm_backlight_device_register.patch
backlight-max8925_bl-use-devm_backlight_device_register.patch
backlight-pandora_bl-use-devm_backlight_device_register.patch
backlight-pcf50633-use-devm_backlight_device_register.patch
backlight-tps65217_bl-use-devm_backlight_device_register.patch
backlight-wm831x_bl-use-devm_backlight_device_register.patch
backlight-hx8357-use-devm_lcd_device_register.patch
backlight-ili922x-use-devm_lcd_device_register.patch
backlight-ili9320-use-devm_lcd_device_register.patch
backlight-lms283gf05-use-devm_lcd_device_register.patch
backlight-lms501kf03-use-devm_lcd_device_register.patch
backlight-ltv350qv-use-devm_lcd_device_register.patch
backlight-platform_lcd-use-devm_lcd_device_register.patch
backlight-tdo24m-use-devm_lcd_device_register.patch
backlight-ams369fg06-use-devm_backlightlcd_device_register.patch
backlight-ld9040-use-devm_backlightlcd_device_register.patch
backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch
backlight-cr_bllcd-use-devm_backlightlcd_device_register.patch
backlight-s6e63m0-use-devm_backlightlcd_device_register.patch
drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
drivers-rtc-rtc-88pm80xc-use-dev_get_platdata.patch
drivers-rtc-rtc-88pm860xc-use-dev_get_platdata.patch
drivers-rtc-rtc-cmosc-use-dev_get_platdata.patch
drivers-rtc-rtc-da9055c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1305c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1307c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds2404c-use-dev_get_platdata.patch
drivers-rtc-rtc-ep93xxc-use-dev_get_platdata.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch
drivers-rtc-rtc-m48t86c-use-dev_get_platdata.patch
drivers-rtc-rtc-pcf2123c-use-dev_get_platdata.patch
drivers-rtc-rtc-rs5c348c-use-dev_get_platdata.patch
drivers-rtc-rtc-shc-use-dev_get_platdata.patch
drivers-rtc-rtc-v3020c-use-dev_get_platdata.patch
gcov-reuse-kbasename-helper.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch
linux-next.patch

