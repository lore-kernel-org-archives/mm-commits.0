From: akpm@linux-foundation.org
Subject: - mac68k-macii-adb-comment-correction.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:54 -0800
Message-ID: <200802052234.m15MYZr7012539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761148AbYBEWmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fthain@telegraphics.com.au, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     mac68k: macii adb comment correction
has been removed from the -mm tree.  Its filename was
     mac68k-macii-adb-comment-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
