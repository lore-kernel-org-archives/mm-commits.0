From: akpm@linux-foundation.org
Subject: [merged] pwm-backlight-take-over-maintenance.patch removed from -mm tree
Date: Wed, 26 Sep 2012 12:35:27 -0700
Message-ID: <20120926193527.C92451E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41085 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab2IZTf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 15:35:29 -0400
Received: by yenr11 with SMTP id r11so113854yen.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 12:35:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thierry.reding@avionic-design.de, acourbot@nvidia.com, arun.murthy@stericsson.com, axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com, dilee@nvidia.com, linus.walleij@linaro.org, mjg@redhat.com, rmorell@nvidia.com, sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pwm-backlight: take over maintenance
has been removed from the -mm tree.  Its filename was
     pwm-backlight-take-over-maintenance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: pwm-backlight: take over maintenance

Since the pwm-backlight driver is lacking a proper maintainer and is the
heaviest user of the PWM framework I'm taking over maintenance.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Arun Murthy <arun.murthy@stericsson.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Robert Morell <rmorell@nvidia.com>
Cc: Dilan Lee <dilee@nvidia.com>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~pwm-backlight-take-over-maintenance MAINTAINERS
--- a/MAINTAINERS~pwm-backlight-take-over-maintenance
+++ a/MAINTAINERS
@@ -5544,6 +5544,8 @@ F:	Documentation/devicetree/bindings/pwm
 F:	include/linux/pwm.h
 F:	include/linux/of_pwm.h
 F:	drivers/pwm/
+F:	drivers/video/backlight/pwm_bl.c
+F:	include/linux/pwm_backlight.h
 
 PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
_

Patches currently in -mm which might be from thierry.reding@avionic-design.de are

origin.patch
linux-next.patch

