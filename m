From: akpm@linux-foundation.org
Subject: + skeletonfb-wrong-field-name-fix.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:25 -0700
Message-ID: <200707261900.l6QJ0Pnd015618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934597AbXGZTBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     skeletonfb: wrong field name fix
has been added to the -mm tree.  Its filename is
     skeletonfb-wrong-field-name-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: skeletonfb: wrong field name fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch corrects name of the field.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-wrong-field-name-fix drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-wrong-field-name-fix
+++ a/drivers/video/skeletonfb.c
@@ -780,7 +780,7 @@ static int __devinit xxxfb_probe(struct 
      *
      * NOTE: This field is currently unused.
      */
-    info->pixmap.scan_align = 32;
+    info->pixmap.access_align = 32;
 /***************************** End optional stage ***************************/
 
     /*
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
