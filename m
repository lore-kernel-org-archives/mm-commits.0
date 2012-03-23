From: akpm@linux-foundation.org
Subject: [folded] lp855x-bl-remove-unnecessary-headers.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:34:53 -0700
Message-ID: <20120323213453.F1D36A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:61159 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab2CWVe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:34:56 -0400
Received: by lbbgj3 with SMTP id gj3so188031lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:34:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, axel.lin@gmail.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lp855x-bl: remove unnecessary headers
has been removed from the -mm tree.  Its filename was
     lp855x-bl-remove-unnecessary-headers.patch

This patch was dropped because it was folded into backlight-new-backlight-driver-for-lp855x-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: lp855x-bl: remove unnecessary headers

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~lp855x-bl-remove-unnecessary-headers drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~lp855x-bl-remove-unnecessary-headers
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -14,8 +14,6 @@
 #include <linux/i2c.h>
 #include <linux/backlight.h>
 #include <linux/err.h>
-#include <linux/debugfs.h>
-#include <linux/uaccess.h>
 #include <linux/lp855x.h>
 
 /* Registers */
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-redefinition-of-register-bits.patch
leds-lm3530-set-the-max_brightness-to-127.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
leds-lm3530-support-pwm-input-mode.patch
leds-lm3530-remove-lm3530_als_zone_reg-code.patch
leds-lm3530-replace-pltfm-with-pdata.patch

