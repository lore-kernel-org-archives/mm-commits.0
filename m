From: akpm@linux-foundation.org
Subject: + pwm-backlight-take-over-maintenance.patch added to -mm tree
Date: Thu, 20 Sep 2012 14:12:24 -0700
Message-ID: <20120920211225.6BB0720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44574 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2ITVM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 17:12:28 -0400
Received: by wgbdt11 with SMTP id dt11so132531wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 14:12:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thierry.reding@avionic-design.de, acourbot@nvidia.com, arun.murthy@stericsson.com, axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com, dilee@nvidia.com, linus.walleij@linaro.org, mjg@redhat.com, rmorell@nvidia.com, sachin.kamat@linaro.org


The patch titled
     Subject: pwm-backlight: take over maintenance
has been added to the -mm tree.  Its filename is
     pwm-backlight-take-over-maintenance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: pwm-backlight: take over maintenance

Since the pwm-backlight driver is lacking a proper maintainer and is the
heaviest user of the PWM framework I'm taking over maintenance.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arun Murthy <arun.murthy@stericsson.com>
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
@@ -5600,6 +5600,8 @@ F:	Documentation/devicetree/bindings/pwm
 F:	include/linux/pwm.h
 F:	include/linux/of_pwm.h
 F:	drivers/pwm/
+F:	drivers/video/backlight/pwm_bl.c
+F:	include/linux/pwm_backlight.h
 
 PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
_

Patches currently in -mm which might be from thierry.reding@avionic-design.de are

linux-next.patch
pwm-backlight-take-over-maintenance.patch

