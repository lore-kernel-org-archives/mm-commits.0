From: akpm@linux-foundation.org
Subject: + backlight-add-new-lm3639-backlight-driver-fix-2.patch added to -mm tree
Date: Wed, 12 Sep 2012 11:52:37 -0700
Message-ID: <20120912185238.25B0820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52091 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2ILSwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 14:52:40 -0400
Received: by fass10 with SMTP id s10so141475fas.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 11:52:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gshark.jeong@gmail.com, rdunlap@xenotime.net


The patch titled
     Subject: backlight-add-new-lm3639-backlight-driver-fix-2
has been added to the -mm tree.  Its filename is
     backlight-add-new-lm3639-backlight-driver-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: backlight-add-new-lm3639-backlight-driver-fix-2

Put NEW_LEDS and LEDS_CLASS into Kconfig file to reduce additional
configuration works in LEDs.

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-add-new-lm3639-backlight-driver-fix-2 drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-new-lm3639-backlight-driver-fix-2
+++ a/drivers/video/backlight/Kconfig
@@ -363,6 +363,8 @@ config BACKLIGHT_LM3639
 	tristate "Backlight Driver for LM3639"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select REGMAP_I2C
+	select NEW_LEDS
+	select LEDS_CLASS
 	help
 	  This supports TI LM3639 Backlight + 1.5A Flash LED Driver
 
_

Patches currently in -mm which might be from gshark.jeong@gmail.com are

linux-next.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-add-new-lm3639-backlight-driver-fix-2.patch

