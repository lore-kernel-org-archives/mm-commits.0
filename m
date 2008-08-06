From: akpm@linux-foundation.org
Subject: - backlight-add-module_alias-to-pwm_backlight-driver.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:45 -0700
Message-ID: <200808062056.m76Kuji3014699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030219AbYHFU6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, rmk@arm.linux.org.uk, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: add MODULE_ALIAS() to pwm_backlight driver
has been removed from the -mm tree.  Its filename was
     backlight-add-module_alias-to-pwm_backlight-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

sm501-update-debugging-low-information-messages.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

