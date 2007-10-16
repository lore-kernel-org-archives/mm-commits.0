From: akpm@linux-foundation.org
Subject: - skeletonfb-wrong-field-name-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:56 -0700
Message-ID: <200710162041.l9GKfuvN015832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934231AbXJPVH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     skeletonfb: wrong field name fix
has been removed from the -mm tree.  Its filename was
     skeletonfb-wrong-field-name-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
