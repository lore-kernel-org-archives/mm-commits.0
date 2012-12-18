From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-da9052_blc-add-missing-const.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:06 -0800
Message-ID: <20121218200507.1F36920005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:55249 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:09 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so63145fav.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, ashish.jangam@kpitcummins.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/da9052_bl.c: add missing const
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-da9052_blc-add-missing-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/da9052_bl.c: add missing const

Add 'const' to static array that was missing it in its definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da9052_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-add-missing-const drivers/video/backlight/da9052_bl.c
--- a/drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-add-missing-const
+++ a/drivers/video/backlight/da9052_bl.c
@@ -34,7 +34,7 @@ enum {
 	DA9052_TYPE_WLED3,
 };
 
-static unsigned char wled_bank[] = {
+static const unsigned char wled_bank[] = {
 	DA9052_LED1_CONF_REG,
 	DA9052_LED2_CONF_REG,
 	DA9052_LED3_CONF_REG,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

