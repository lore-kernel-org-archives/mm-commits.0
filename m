From: akpm@linux-foundation.org
Subject: + drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y.patch added to -mm tree
Date: Thu, 21 Oct 2010 15:25:54 -0700
Message-ID: <201010212225.o9LMPsEv007274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756684Ab0JUW01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 18:26:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, jirislaby@gmail.com, mmarek@suse.cz


The patch titled
     drivers/char/rio/Makefile: replace the use of <module>-objs with <module>-y
has been added to the -mm tree.  Its filename is
     drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y.patch

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
Subject: drivers/char/rio/Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/rio/Makefile~drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y drivers/char/rio/Makefile
--- a/drivers/char/rio/Makefile~drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/char/rio/Makefile
@@ -8,5 +8,5 @@
 
 obj-$(CONFIG_RIO) += rio.o
 
-rio-objs := rio_linux.o rioinit.o rioboot.o riocmd.o rioctrl.o riointr.o \
+rio-y := rio_linux.o rioinit.o rioboot.o riocmd.o rioctrl.o riointr.o \
             rioparam.o rioroute.o riotable.o riotty.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch
drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-mwave-makefile-clean-up.patch
drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y.patch

