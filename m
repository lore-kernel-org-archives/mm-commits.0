From: akpm@linux-foundation.org
Subject: + fbmem-ix-whitespace.patch added to -mm tree
Date: Fri, 17 Sep 2010 15:08:25 -0700
Message-ID: <201009172208.o8HM8Phj012794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab0IQWIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 18:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james@albanarts.com


The patch titled
     fbmem: ix whitespace
has been added to the -mm tree.  Its filename is
     fbmem-ix-whitespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbmem: ix whitespace
From: James Hogan <james@albanarts.com>

Change a few lines of indentation to tabs.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/video/fbmem.c~fbmem-ix-whitespace drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbmem-ix-whitespace
+++ a/drivers/video/fbmem.c
@@ -877,13 +877,13 @@ fb_pan_display(struct fb_info *info, str
 
 	if ((err = info->fbops->fb_pan_display(var, info)))
 		return err;
-        info->var.xoffset = var->xoffset;
-        info->var.yoffset = var->yoffset;
-        if (var->vmode & FB_VMODE_YWRAP)
-                info->var.vmode |= FB_VMODE_YWRAP;
-        else
-                info->var.vmode &= ~FB_VMODE_YWRAP;
-        return 0;
+	info->var.xoffset = var->xoffset;
+	info->var.yoffset = var->yoffset;
+	if (var->vmode & FB_VMODE_YWRAP)
+		info->var.vmode |= FB_VMODE_YWRAP;
+	else
+		info->var.vmode &= ~FB_VMODE_YWRAP;
+	return 0;
 }
 
 static int fb_check_caps(struct fb_info *info, struct fb_var_screeninfo *var,
_

Patches currently in -mm which might be from james@albanarts.com are

fbmem-ix-whitespace.patch

