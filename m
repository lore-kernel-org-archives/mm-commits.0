From: akpm@linux-foundation.org
Subject: + backlight-add-an-as3711-pmic-backlight-driver-fix.patch added to -mm tree
Date: Wed, 06 Feb 2013 12:29:25 -0800
Message-ID: <20130206202925.B7ABB5A4173@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:46445 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab3BFU30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 15:29:26 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so194302qen.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 12:29:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de


The patch titled
     Subject: backlight: as3711: fix compilation breakage
has been added to the -mm tree.  Its filename is
     backlight-add-an-as3711-pmic-backlight-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: backlight: as3711: fix compilation breakage

Include the missing platform_device.h header to fix errors like

error: implicit declaration of function 'platform_set_drvdata'

and similar.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/as3711_bl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/as3711_bl.c~backlight-add-an-as3711-pmic-backlight-driver-fix drivers/video/backlight/as3711_bl.c
--- a/drivers/video/backlight/as3711_bl.c~backlight-add-an-as3711-pmic-backlight-driver-fix
+++ a/drivers/video/backlight/as3711_bl.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/mfd/as3711.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
backlight-add-an-as3711-pmic-backlight-driver.patch
backlight-add-an-as3711-pmic-backlight-driver-fix.patch

