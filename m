From: akpm@linux-foundation.org
Subject: - wm9712-bump-version-number.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:38:22 -0700
Message-ID: <200804012138.m31LcMSm014920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400AbYDAVrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, gg@opensource.wolfsonmicro.com, liam.girdwood@wolfsonmicro.com, mike.arthur@wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     wm9712: bump version number
has been removed from the -mm tree.  Its filename was
     wm9712-bump-version-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wm9712: bump version number
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Graeme Gregory <gg@opensource.wolfsonmicro.com>
Cc: Mike Arthur <mike.arthur@wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm9712.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/wm9712.c~wm9712-bump-version-number drivers/input/touchscreen/wm9712.c
--- a/drivers/input/touchscreen/wm9712.c~wm9712-bump-version-number
+++ a/drivers/input/touchscreen/wm9712.c
@@ -25,7 +25,7 @@
 #include <linux/wm97xx.h>
 
 #define TS_NAME			"wm97xx"
-#define WM9712_VERSION		"0.61"
+#define WM9712_VERSION		"1.00"
 #define DEFAULT_PRESSURE	0xb0c0
 
 /*
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa-tiwai.patch
git-arm.patch
git-wm97xx.patch
touch-screen-driver-for-the-superh-migor-board.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch

