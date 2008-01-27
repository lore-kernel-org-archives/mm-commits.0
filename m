From: akpm@linux-foundation.org
Subject: + ps3fb-fix-modedb-typos.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:42 -0800
Message-ID: <200801270514.m0R5Edmf031023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbYA0FO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geoffrey.levand@am.sony.com, Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: fix modedb typos
has been added to the -mm tree.  Its filename is
     ps3fb-fix-modedb-typos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ps3fb: fix modedb typos
From: Geoff Levand <geoffrey.levand@am.sony.com>

Fix modedb typos

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-fix-modedb-typos drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-fix-modedb-typos
+++ a/drivers/video/ps3fb.c
@@ -184,7 +184,7 @@ static const struct fb_videomode ps3fb_m
         "720p", 50, 1124, 644, 13468, 298, 478, 57, 44, 80, 5,
         FB_SYNC_BROADCAST, FB_VMODE_NONINTERLACED
     },    {
-        /* 1080 */
+        /* 1080i */
         "1080i", 50, 1688, 964, 13468, 264, 600, 94, 62, 88, 5,
         FB_SYNC_BROADCAST, FB_VMODE_INTERLACED
     },    {
@@ -232,7 +232,7 @@ static const struct fb_videomode ps3fb_m
 	FB_SYNC_BROADCAST, FB_VMODE_NONINTERLACED
     }, {
 	/* 1080if */
-	"1080f", 50, 1920, 1080, 13468, 148, 484, 36, 4, 88, 5,
+	"1080if", 50, 1920, 1080, 13468, 148, 484, 36, 4, 88, 5,
 	FB_SYNC_BROADCAST, FB_VMODE_INTERLACED
     }, {
 	/* 1080pf */
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.com are

git-powerpc.patch
ps3fb-fix-modedb-typos.patch
