From: akpm@linux-foundation.org
Subject: + drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long-update.patch added to -mm tree
Date: Fri, 18 Jun 2010 15:52:53 -0700
Message-ID: <201006182252.o5IMqr9D027964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab0FRWxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 18:53:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiaochong@loongson.cn


The patch titled
     drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long-update
has been added to the -mm tree.  Its filename is
     drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long-update.patch

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
Subject: drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long-update
From: qiaochong <qiaochong@loongson.cn>

Signed-off-by: qiaochong <qiaochong@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/vt.c~drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long-update drivers/char/vt.c
--- a/drivers/char/vt.c~drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long-update
+++ a/drivers/char/vt.c
@@ -836,7 +836,8 @@ static inline int resize_screen(struct v
 static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 				unsigned int cols, unsigned int lines)
 {
-	unsigned long old_origin, new_origin, new_scr_end, end, rlth, rrem, err = 0;
+	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
+	unsigned long end;
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
 	unsigned int user;
_

Patches currently in -mm which might be from qiaochong@loongson.cn are

fix-vc-vc_origin-on-take_over_console.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long.patch
drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long-update.patch

