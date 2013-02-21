From: akpm@linux-foundation.org
Subject: [folded-merged] backlight-add-lms501kf03-lcd-driver-fix-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:19:47 -0800
Message-ID: <20130221231947.D9D7C31C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:38993 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3BUXTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:19:48 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so10503yen.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:19:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Ilho215.lee@samsung.com, devendra.aaru@gmail.com, fengguang.wu@intel.com, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-lms501kf03-lcd-driver-fix-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-lms501kf03-lcd-driver-fix-fix.patch

This patch was dropped because it was folded into backlight-add-lms501kf03-lcd-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-lms501kf03-lcd-driver-fix-fix

make lms501kf03_shutdown() static, per Fengguang

Cc: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Ilho Lee <Ilho215.lee@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms501kf03.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lms501kf03.c~backlight-add-lms501kf03-lcd-driver-fix-fix drivers/video/backlight/lms501kf03.c
--- a/drivers/video/backlight/lms501kf03.c~backlight-add-lms501kf03-lcd-driver-fix-fix
+++ a/drivers/video/backlight/lms501kf03.c
@@ -415,7 +415,7 @@ static int lms501kf03_resume(struct spi_
 #define lms501kf03_resume	NULL
 #endif
 
-void lms501kf03_shutdown(struct spi_device *spi)
+static void lms501kf03_shutdown(struct spi_device *spi)
 {
 	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch

