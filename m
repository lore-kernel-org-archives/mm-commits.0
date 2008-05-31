From: akpm@linux-foundation.org
Subject: + drivers-char-ip2-fix-kconfig-after-ip2-ip2main-merge.patch added to -mm tree
Date: Fri, 30 May 2008 17:55:32 -0700
Message-ID: <200805310055.m4V0tW3F020173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYEaA4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devzero@web.de, alan@redhat.com, jirislaby@gmail.com


The patch titled
     drivers/char/ip2: fix Kconfig after ip2/ip2main merge
has been added to the -mm tree.  Its filename is
     drivers-char-ip2-fix-kconfig-after-ip2-ip2main-merge.patch

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
Subject: drivers/char/ip2: fix Kconfig after ip2/ip2main merge
From: devzero@web.de

As commit 6089093e588ee3f6aed99d08b1cf5ea37c52cf97 is fixing ip2 crashes
on load/unload and making ip2/ip2main one module (ip2), Kconfig shouldn't
mention a non existing module.

Signed-off-by: Roland.Kletzing <devzero@web.de>
Cc: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/Kconfig~drivers-char-ip2-fix-kconfig-after-ip2-ip2main-merge drivers/char/Kconfig
--- a/drivers/char/Kconfig~drivers-char-ip2-fix-kconfig-after-ip2-ip2main-merge
+++ a/drivers/char/Kconfig
@@ -118,8 +118,8 @@ config COMPUTONE
 	  order to become a dial-in server. If you have a card like that, say
 	  Y here and read <file:Documentation/computone.txt>.
 
-	  To compile this driver as modules, choose M here: the
-	  modules will be called ip2 and ip2main.
+         To compile this driver as module, choose M here: the
+         module will be called ip2.
 
 config ROCKETPORT
 	tristate "Comtrol RocketPort support"
_

Patches currently in -mm which might be from devzero@web.de are

drivers-char-ip2-fix-kconfig-after-ip2-ip2main-merge.patch
mdacon-messing-up-default-vcs-set-default-to-vc13-16-again.patch

