From: akpm@linux-foundation.org
Subject: [merged] backlight-vgg2432a4-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:47 -0800
Message-ID: <20121218200447.A2A42100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:39468 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:48 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so125385ggm.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: vgg2432a4: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-vgg2432a4-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: vgg2432a4: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/vgg2432a4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/vgg2432a4.c~backlight-vgg2432a4-fix-checkpatch-warning drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~backlight-vgg2432a4-fix-checkpatch-warning
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -217,7 +217,7 @@ static int vgg2432a4_resume(struct spi_d
 }
 #else
 #define vgg2432a4_suspend	NULL
-#define vgg2432a4_resume 	NULL
+#define vgg2432a4_resume	NULL
 #endif
 
 static struct ili9320_client vgg2432a4_client = {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

