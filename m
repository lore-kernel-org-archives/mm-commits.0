From: akpm@linux-foundation.org
Subject: + drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y.patch added to -mm tree
Date: Thu, 21 Oct 2010 15:25:46 -0700
Message-ID: <201010212225.o9LMPkgJ007262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758876Ab0JUW0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 18:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, jirislaby@gmail.com, mmarek@suse.cz


The patch titled
     drivers/char/ip2/Makefile: replace the use of <module>-objs with <module>-y
has been added to the -mm tree.  Its filename is
     drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y.patch

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
Subject: drivers/char/ip2/Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ip2/Makefile~drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y drivers/char/ip2/Makefile
--- a/drivers/char/ip2/Makefile~drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/char/ip2/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_COMPUTONE)         += ip2.o
 
-ip2-objs			:= ip2main.o
+ip2-y			:= ip2main.o
 
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch
drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-mwave-makefile-clean-up.patch
drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y.patch

