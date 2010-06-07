From: akpm@linux-foundation.org
Subject: + char-remove-unused-variable.patch added to -mm tree
Date: Mon, 07 Jun 2010 16:06:13 -0700
Message-ID: <201006072306.o57N6DKC000784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab0FGXG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jun 2010 19:06:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     drivers/char/isicom.c: remove unused variable
has been added to the -mm tree.  Its filename is
     char-remove-unused-variable.patch

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
Subject: drivers/char/isicom.c: remove unused variable
From: Richard Weinberger <richard@nod.at>

card is never used within isicom_open().

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/isicom.c~char-remove-unused-variable drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-remove-unused-variable
+++ a/drivers/char/isicom.c
@@ -872,7 +872,6 @@ static struct tty_port *isicom_find_port
 static int isicom_open(struct tty_struct *tty, struct file *filp)
 {
 	struct isi_port *port;
-	struct isi_board *card;
 	struct tty_port *tport;
 
 	tport = isicom_find_port(tty);
_

Patches currently in -mm which might be from richard@nod.at are

char-remove-unused-variable.patch

