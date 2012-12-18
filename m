From: akpm@linux-foundation.org
Subject: [merged] backlight-omap1-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:30 -0800
Message-ID: <20121218200431.46E0520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:48191 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:33 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so63235wib.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: omap1: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-omap1-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: omap1: fix checkpatch warning

This patch fixes the checkpatch warning as below:

ERROR: inline keyword should sit between storage class and type

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/omap1_bl.c~backlight-omap1-fix-checkpatch-warning drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-omap1-fix-checkpatch-warning
+++ a/drivers/video/backlight/omap1_bl.c
@@ -42,12 +42,12 @@ struct omap_backlight {
 	struct omap_backlight_config *pdata;
 };
 
-static void inline omapbl_send_intensity(int intensity)
+static inline void omapbl_send_intensity(int intensity)
 {
 	omap_writeb(intensity, OMAP_PWL_ENABLE);
 }
 
-static void inline omapbl_send_enable(int enable)
+static inline void omapbl_send_enable(int enable)
 {
 	omap_writeb(enable, OMAP_PWL_CLK_ENABLE);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

