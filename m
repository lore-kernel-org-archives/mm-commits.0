From: akpm@linux-foundation.org
Subject: + include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness.patch added to -mm tree
Date: Fri, 20 Apr 2012 16:10:27 -0700
Message-ID: <20120420231027.AFA84A0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46967 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab2DTXKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 19:10:30 -0400
Received: by wejx9 with SMTP id x9so480306wej.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 16:10:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com


The patch titled
     Subject: include/linux/led-lm3530.h: comment correction about the range of brightness
has been added to the -mm tree.  Its filename is
     include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness.patch

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
Subject: include/linux/led-lm3530.h: comment correction about the range of brightness

max brightness is 127, so the range of brt_val should be from 0 to 127

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
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
Subject: Subject: include/linux/led-lm3530.h: comment correction about the range of brightness

Patches currently in -mm which might be from Milo.Kim@ti.com are

drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness.patch

