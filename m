From: akpm@linux-foundation.org
Subject: + backlight-add-module_alias-to-pwm_backlight-driver.patch added to -mm tree
Date: Tue, 29 Jul 2008 16:50:38 -0700
Message-ID: <200807292350.m6TNoc7l028575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbYG2Xva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 19:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, rmk@arm.linux.org.uk, rpurdie@rpsys.net


The patch titled
     backlight: add MODULE_ALIAS() to pwm_backlight driver
has been added to the -mm tree.  Its filename is
     backlight-add-module_alias-to-pwm_backlight-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: add MODULE_ALIAS() to pwm_backlight driver
From: Ben Dooks <ben-linux@fluff.org>

Add the missing MODULE_ALIAS() to the pwm_backlight driver.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/pwm_bl.c~backlight-add-module_alias-to-pwm_backlight-driver drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-add-module_alias-to-pwm_backlight-driver
+++ a/drivers/video/backlight/pwm_bl.c
@@ -187,3 +187,5 @@ module_exit(pwm_backlight_exit);
 
 MODULE_DESCRIPTION("PWM based Backlight Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pwm-backlight");
+
_

Patches currently in -mm which might be from ben-linux@fluff.org are

backlight-give-platform_lcd-the-same-name-as-the-platform-device.patch
resource-add-resource_size.patch
backlight-ensure-platform_lcd-on-by-default.patch
scripts-mod-modpostc-fix-spelling-of-module-and-happens.patch
linux-next.patch
backlight-add-more-information-output-to-pwm_backlight.patch
backlight-add-module_alias-to-pwm_backlight-driver.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

