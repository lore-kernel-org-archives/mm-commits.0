From: akpm@linux-foundation.org
Subject: [merged] backlight-generic_bl-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:07 -0800
Message-ID: <20121218200408.1E05B20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:57423 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:10 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so63121fav.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: generic_bl: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-generic_bl-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: generic_bl: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/generic_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/generic_bl.c~backlight-generic_bl-fix-checkpatch-warning drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-generic_bl-fix-checkpatch-warning
+++ a/drivers/video/backlight/generic_bl.c
@@ -97,8 +97,8 @@ static int genericbl_probe(struct platfo
 	props.max_brightness = machinfo->max_intensity;
 	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
 				       &props);
-	if (IS_ERR (bd))
-		return PTR_ERR (bd);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 
 	platform_set_drvdata(pdev, bd);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

