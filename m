From: akpm@linux-foundation.org
Subject: [merged] include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:43 -0700
Message-ID: <20120531191943.6CCF0A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58177 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab2EaTTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:44 -0400
Received: by mail-vc0-f202.google.com with SMTP id fl13so135276vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, bryan.wu@canonical.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/led-lm3530.h: comment correction about the range of brightness
has been removed from the -mm tree.  Its filename was
     include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: include/linux/led-lm3530.h: comment correction about the range of brightness

max brightness is 127, so the range of brt_val should be from 0 to 127

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/led-lm3530.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/led-lm3530.h~include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness include/linux/led-lm3530.h
--- a/include/linux/led-lm3530.h~include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness
+++ a/include/linux/led-lm3530.h
@@ -92,7 +92,7 @@ struct lm3530_pwm_data {
  * @als2_resistor_sel: internal resistance from ALS2 input to ground
  * @als_vmin: als input voltage calibrated for max brightness in mV
  * @als_vmax: als input voltage calibrated for min brightness in mV
- * @brt_val: brightness value (0-255)
+ * @brt_val: brightness value (0-127)
  * @pwm_data: PWM control functions (only valid when the mode is PWM)
  */
 struct lm3530_platform_data {
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch

