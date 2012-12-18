From: akpm@linux-foundation.org
Subject: [merged] backlight-atmel-pwm-bl-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:56 -0800
Message-ID: <20121218200357.1645A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:38758 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:59 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so63364wey.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: atmel-pwm-bl: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-atmel-pwm-bl-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: atmel-pwm-bl: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-fix-checkpatch-warning drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-fix-checkpatch-warning
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -106,10 +106,9 @@ static int atmel_pwm_bl_init_pwm(struct 
 	pwm_channel_writel(&pwmbl->pwmc, PWM_CPRD,
 			pwmbl->pdata->pwm_compare_max);
 
-	dev_info(&pwmbl->pdev->dev, "Atmel PWM backlight driver "
-			"(%lu Hz)\n", pwmbl->pwmc.mck /
-			pwmbl->pdata->pwm_compare_max /
-			(1 << prescale));
+	dev_info(&pwmbl->pdev->dev, "Atmel PWM backlight driver (%lu Hz)\n",
+		pwmbl->pwmc.mck / pwmbl->pdata->pwm_compare_max /
+		(1 << prescale));
 
 	return pwm_channel_enable(&pwmbl->pwmc);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

