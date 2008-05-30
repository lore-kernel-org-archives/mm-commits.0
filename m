From: akpm@linux-foundation.org
Subject: - wm97xx-core-fix-driver-name.patch removed from -mm tree
Date: Fri, 30 May 2008 15:39:13 -0700
Message-ID: <200805302239.m4UMdDSB014892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbYE3Wk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, g.liakhovetski@gmx.de, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     wm97xx-core: fix driver name
has been removed from the -mm tree.  Its filename was
     wm97xx-core-fix-driver-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-regulator.patch

