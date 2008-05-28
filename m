From: akpm@linux-foundation.org
Subject: + wm97xx-core-fix-driver-name.patch added to -mm tree
Date: Wed, 28 May 2008 16:03:43 -0700
Message-ID: <200805282303.m4SN3hdt004852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061AbYE1XFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, g.liakhovetski@gmx.de, giometti@enneenne.com


The patch titled
     wm97xx-core: fix driver name
has been added to the -mm tree.  Its filename is
     wm97xx-core-fix-driver-name.patch

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
Subject: wm97xx-core: fix driver name
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Fix driver name - thanks to Guennadi Liakhovetski for reporting this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/wm97xx-core.c~wm97xx-core-fix-driver-name drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~wm97xx-core-fix-driver-name
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -802,7 +802,7 @@ void wm97xx_unregister_mach_ops(struct w
 EXPORT_SYMBOL_GPL(wm97xx_unregister_mach_ops);
 
 static struct device_driver wm97xx_driver = {
-	.name =		"ac97",
+	.name =		"wm97xx-ts",
 	.bus =		&ac97_bus_type,
 	.owner =	THIS_MODULE,
 	.probe =	wm97xx_probe,
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
wm97xx-core-report-a-phys-for-wm97xx-touchscreens.patch
wm97xx-core-fix-driver-name.patch
wm97xx-core-fix-race-on-phy-init.patch
wm9713-support-five-wire-panels.patch
git-regulator.patch

