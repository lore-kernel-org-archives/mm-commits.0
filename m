From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-ab8500-pwmc-fix-modalias.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:07:00 -0700
Message-ID: <201108261903.p7QJ3iBV005718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab1HZTER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, arun.murthy@stericsson.com, linus.walleij@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/ab8500-pwm.c: fix modalias
has been removed from the -mm tree.  Its filename was
     drivers-misc-ab8500-pwmc-fix-modalias.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -164,5 +164,5 @@ subsys_initcall(ab8500_pwm_init);
 module_exit(ab8500_pwm_exit);
 MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
 MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
-MODULE_ALIAS("AB8500 PWM driver");
+MODULE_ALIAS("platform:ab8500-pwm");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

