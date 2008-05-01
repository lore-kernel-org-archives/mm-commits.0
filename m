From: akpm@linux-foundation.org
Subject: + drivers-char-synclinkc-inbreak-mgsl_put_char-fix.patch added to -mm tree
Date: Thu, 01 May 2008 03:33:48 -0700
Message-ID: <200805011033.m41AXmnr000947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbYEAKeb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 06:34:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, paulkf@microgate.com


The patch titled
     drivers-char-synclinkc-inbreak-mgsl_put_char-fix
has been added to the -mm tree.  Its filename is
     drivers-char-synclinkc-inbreak-mgsl_put_char-fix.patch

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
Subject: drivers-char-synclinkc-inbreak-mgsl_put_char-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/synclink.c~drivers-char-synclinkc-inbreak-mgsl_put_char-fix drivers/char/synclink.c
--- a/drivers/char/synclink.c~drivers-char-synclinkc-inbreak-mgsl_put_char-fix
+++ a/drivers/char/synclink.c
@@ -2033,7 +2033,7 @@ static int mgsl_put_char(struct tty_stru
 	int ret = 0;
 
 	if (debug_level >= DEBUG_LEVEL_INFO) {
-		printk("%s(%d):mgsl_put_char(%d) on %s\n",
+		printk(KERN_DEBUG "%s(%d):mgsl_put_char(%d) on %s\n",
 			__FILE__, __LINE__, ch, info->device_name);
 	}		
 	
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pnp-fix-printk-format-warnings.patch
drivers-char-synclinkc-inbreak-mgsl_put_char.patch
drivers-char-synclinkc-inbreak-mgsl_put_char-fix.patch

