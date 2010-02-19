From: akpm@linux-foundation.org
Subject: + video-fix-first-line-of-kernel-doc-for-a-few-functions.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:09:46 -0800
Message-ID: <201002192109.o1JL9kGd004399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab0BSVK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:10:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk


The patch titled
     video: fix first line of kernel-doc for a few functions
has been added to the -mm tree.  Its filename is
     video-fix-first-line-of-kernel-doc-for-a-few-functions.patch

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
Subject: video: fix first line of kernel-doc for a few functions
From: Ben Hutchings <ben@decadent.org.uk>

The function name must be followed by a space, hypen, space, and a short
description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/modedb.c~video-fix-first-line-of-kernel-doc-for-a-few-functions drivers/video/modedb.c
--- a/drivers/video/modedb.c~video-fix-first-line-of-kernel-doc-for-a-few-functions
+++ a/drivers/video/modedb.c
@@ -893,7 +893,7 @@ const struct fb_videomode *fb_match_mode
 }
 
 /**
- * fb_add_videomode: adds videomode entry to modelist
+ * fb_add_videomode - adds videomode entry to modelist
  * @mode: videomode to add
  * @head: struct list_head of modelist
  *
@@ -928,7 +928,7 @@ int fb_add_videomode(const struct fb_vid
 }
 
 /**
- * fb_delete_videomode: removed videomode entry from modelist
+ * fb_delete_videomode - removed videomode entry from modelist
  * @mode: videomode to remove
  * @head: struct list_head of modelist
  *
@@ -953,7 +953,7 @@ void fb_delete_videomode(const struct fb
 }
 
 /**
- * fb_destroy_modelist: destroy modelist
+ * fb_destroy_modelist - destroy modelist
  * @head: struct list_head of modelist
  */
 void fb_destroy_modelist(struct list_head *head)
@@ -968,7 +968,7 @@ void fb_destroy_modelist(struct list_hea
 EXPORT_SYMBOL_GPL(fb_destroy_modelist);
 
 /**
- * fb_videomode_to_modelist: convert mode array to mode list
+ * fb_videomode_to_modelist - convert mode array to mode list
  * @modedb: array of struct fb_videomode
  * @num: number of entries in array
  * @head: struct list_head of modelist
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch
lib-fix-first-line-of-kernel-doc-for-a-few-functions.patch
video-fix-first-line-of-kernel-doc-for-a-few-functions.patch

