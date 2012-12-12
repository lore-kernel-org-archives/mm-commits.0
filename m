From: akpm@linux-foundation.org
Subject: + maintainers-add-lp855x-backlight-driver-entry.patch added to -mm tree
Date: Wed, 12 Dec 2012 13:12:22 -0800
Message-ID: <20121212211223.06E00200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:37726 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab2LLVMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:12:25 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so67939eaa.4
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:12:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: MAINTAINERS: add LP855x backlight driver entry
has been added to the -mm tree.  Its filename is
     maintainers-add-lp855x-backlight-driver-entry.patch

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
Subject: MAINTAINERS: add LP855x backlight driver entry

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-lp855x-backlight-driver-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-lp855x-backlight-driver-entry
+++ a/MAINTAINERS
@@ -7308,6 +7308,13 @@ S:	Maintained
 F:	sound/soc/codecs/lm49453*
 F:	sound/soc/codecs/isabelle*
 
+TI LP855x BACKLIGHT DRIVER
+M:	Milo Kim <milo.kim@ti.com>
+S:	Maintained
+F:	Documentation/backlight/lp855x-driver.txt
+F:	drivers/video/backlight/lp855x_bl.c
+F:	include/linux/platform_data/lp855x.h
+
 TI TWL4030 SERIES SOC CODEC DRIVER
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

linux-next.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch
maintainers-add-lp855x-backlight-driver-entry.patch
drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization.patch

