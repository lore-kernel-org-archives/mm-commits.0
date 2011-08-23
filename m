From: akpm@linux-foundation.org
Subject: + drivers-misc-ab8500-pwmc-fix-modalias.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:31:31 -0700
Message-ID: <201108232031.p7NKVVRD004936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755797Ab1HWUcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:32:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, arun.murthy@stericsson.com, linus.walleij@stericsson.com


The patch titled
     drivers/misc/ab8500-pwm.c: fix modalias
has been added to the -mm tree.  Its filename is
     drivers-misc-ab8500-pwmc-fix-modalias.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/ab8500-pwm.c: fix modalias
From: Axel Lin <axel.lin@gmail.com>

Since 43cc71eed1250 ("platform: prefix MODALIAS with "platform:""), the
platform modalias is prefixed with "platform:".

This patch changes the MODULE_ALIAS to "platform:ab8500-pwm".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Arun Murthy <arun.murthy@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ab8500-pwm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/ab8500-pwm.c~drivers-misc-ab8500-pwmc-fix-modalias drivers/misc/ab8500-pwm.c
--- a/drivers/misc/ab8500-pwm.c~drivers-misc-ab8500-pwmc-fix-modalias
+++ a/drivers/misc/ab8500-pwm.c
@@ -165,5 +165,5 @@ subsys_initcall(ab8500_pwm_init);
 module_exit(ab8500_pwm_exit);
 MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
 MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
-MODULE_ALIAS("AB8500 PWM driver");
+MODULE_ALIAS("platform:ab8500-pwm");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch
leds-add-missing-include-of-linux-moduleh.patch
backlight-fix-module-alias-prefix-for-adp8870_bl.patch
drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure.patch
drivers-misc-ab8500-pwmc-fix-modalias.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

