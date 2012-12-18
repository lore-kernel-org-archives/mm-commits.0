From: akpm@linux-foundation.org
Subject: [merged] backlight-lm3630-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:27 -0800
Message-ID: <20121218200428.2340E82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48553 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:29 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so125433qcq.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lm3630: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-lm3630-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lm3630: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: static const char * array should probably be static const char * const

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lm3630_bl.c~backlight-lm3630-fix-checkpatch-warning drivers/video/backlight/lm3630_bl.c
--- a/drivers/video/backlight/lm3630_bl.c~backlight-lm3630-fix-checkpatch-warning
+++ a/drivers/video/backlight/lm3630_bl.c
@@ -37,7 +37,7 @@ enum lm3630_leds {
 	BLED_2
 };
 
-static const char *bled_name[] = {
+static const char * const bled_name[] = {
 	[BLED_ALL] = "lm3630_bled",	/*Bank1 controls all string */
 	[BLED_1] = "lm3630_bled1",	/*Bank1 controls bled1 */
 	[BLED_2] = "lm3630_bled2",	/*Bank1 or 2 controls bled2 */
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

