From: akpm@linux-foundation.org
Subject: + backlight-lp855x-remove-unnecessary-parentheses.patch added to
 -mm tree
Date: Tue, 07 Jan 2014 14:11:38 -0800
Message-ID: <52cc7b9a.arlMfVVfHhNPwGSw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaAGWLj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 17:11:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-lp855x-remove-unnecessary-parentheses.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 14:11:38 -0800


The patch titled
     Subject: backlight: lp855x: remove unnecessary parentheses
has been added to the -mm tree.  Its filename is
     backlight-lp855x-remove-unnecessary-parentheses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lp855x-remove-unnecessary-parentheses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lp855x-remove-unnecessary-parentheses.patch

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
Subject: backlight: lp855x: remove unnecessary parentheses

Remove unnecessary parentheses in order to fix the following checkpatch
error.

  ERROR: return is not a function, parentheses are not required

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-remove-unnecessary-parentheses drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-remove-unnecessary-parentheses
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -125,7 +125,7 @@ static bool lp855x_is_valid_rom_area(str
 		return false;
 	}
 
-	return (addr >= start && addr <= end);
+	return addr >= start && addr <= end;
 }
 
 static int lp8557_bl_off(struct lp855x *lp)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
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

