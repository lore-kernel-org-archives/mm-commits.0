From: akpm@linux-foundation.org
Subject: + drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y.patch added to -mm tree
Date: Thu, 21 Oct 2010 15:25:52 -0700
Message-ID: <201010212225.o9LMPq4T007271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758859Ab0JUW01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 18:26:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, dsterba@suse.cz, jirislaby@gmail.com, jkosina@suse.cz, mmarek@suse.cz


The patch titled
     drivers/char/pcmcia/ipwireless/Makefile: Makefile: replace the use of <module>-objs with <module>-y
has been added to the -mm tree.  Its filename is
     drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y.patch

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
Subject: drivers/char/pcmcia/ipwireless/Makefile: Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/ipwireless/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/pcmcia/ipwireless/Makefile~drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y drivers/char/pcmcia/ipwireless/Makefile
--- a/drivers/char/pcmcia/ipwireless/Makefile~drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/char/pcmcia/ipwireless/Makefile
@@ -6,5 +6,5 @@
 
 obj-$(CONFIG_IPWIRELESS) += ipwireless.o
 
-ipwireless-objs := hardware.o main.o network.o tty.o
+ipwireless-y := hardware.o main.o network.o tty.o
 
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch
drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-mwave-makefile-clean-up.patch
drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y.patch

