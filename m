From: akpm@linux-foundation.org
Subject: + lp855x-bl-remove-unnecessary-headers.patch added to -mm tree
Date: Tue, 21 Feb 2012 14:08:13 -0800
Message-ID: <20120221220813.B8417A00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47763 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab2BUWIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2012 17:08:15 -0500
Received: by eaaf13 with SMTP id f13so228443eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2012 14:08:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, axel.lin@gmail.com, milo.kim@ti.com


The patch titled
     Subject: lp855x-bl: remove unnecessary headers
has been added to the -mm tree.  Its filename is
     lp855x-bl-remove-unnecessary-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: lp855x-bl: remove unnecessary headers

Patches currently in -mm which might be from Milo.Kim@ti.com are

linux-next.patch
backlight-new-backlight-driver-for-lp855x-devices.patch
lp855x-bl-remove-unnecessary-platform-data.patch
lp855x-bl-remove-unnecessary-headers.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
leds-lp5521-redefinition-of-register-bits.patch
leds-lm3530-set-the-max_brightness-to-127.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
leds-lm3530-support-pwm-input-mode.patch
leds-lm3530-remove-lm3530_als_zone_reg-code.patch
leds-lm3530-replace-pltfm-with-pdata.patch

