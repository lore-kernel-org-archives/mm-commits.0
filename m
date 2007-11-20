From: akpm@linux-foundation.org
Subject: + mac68k-macii-adb-comment-correction.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:15:10 -0800
Message-ID: <200711200215.lAK2FAmu008967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762730AbXKTCP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fthain@telegraphics.com.au, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     mac68k: macii adb comment correction
has been added to the -mm tree.  Its filename is
     mac68k-macii-adb-comment-correction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mac68k: macii adb comment correction
From: Finn Thain <fthain@telegraphics.com.au>

Corrects a mistake I made in a comment.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/via-macii.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/via-macii.c~mac68k-macii-adb-comment-correction drivers/macintosh/via-macii.c
--- a/drivers/macintosh/via-macii.c~mac68k-macii-adb-comment-correction
+++ a/drivers/macintosh/via-macii.c
@@ -111,7 +111,7 @@ static enum macii_state {
 static struct adb_request *current_req; /* first request struct in the queue */
 static struct adb_request *last_req;     /* last request struct in the queue */
 static unsigned char reply_buf[16];        /* storage for autopolled replies */
-static unsigned char *reply_ptr;      /* next byte in req->data or reply_buf */
+static unsigned char *reply_ptr;     /* next byte in reply_buf or req->reply */
 static int reading_reply;        /* store reply in reply_buf else req->reply */
 static int data_index;      /* index of the next byte to send from req->data */
 static int reply_len; /* number of bytes received in reply_buf or req->reply */
_

Patches currently in -mm which might be from fthain@telegraphics.com.au are

mac68k-mailing-list-addresss.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
