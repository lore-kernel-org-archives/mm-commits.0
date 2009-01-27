From: akpm@linux-foundation.org
Subject: + fbdev-incorrect-url-given-in-drivers-video-kconfig.patch added to -mm tree
Date: Mon, 26 Jan 2009 19:34:31 -0800
Message-ID: <200901270334.n0R3YVIC000944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885AbZA0Dei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 22:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.buell@munted.org.uk


The patch titled
     fbdev: incorrect URL given in drivers/video/Kconfig
has been added to the -mm tree.  Its filename is
     fbdev-incorrect-url-given-in-drivers-video-kconfig.patch

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
Subject: fbdev: incorrect URL given in drivers/video/Kconfig
From: Alex Buell <alex.buell@munted.org.uk>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~fbdev-incorrect-url-given-in-drivers-video-kconfig drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-incorrect-url-given-in-drivers-video-kconfig
+++ a/drivers/video/Kconfig
@@ -41,7 +41,7 @@ menuconfig FB
 	  You need an utility program called fbset to make full use of frame
 	  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
 	  and the Framebuffer-HOWTO at
-	  <http://www.tahallah.demon.co.uk/programming/prog.html> for more
+	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.2.html> for more
 	  information.
 
 	  Say Y here and to the driver for your graphics board below if you
_

Patches currently in -mm which might be from alex.buell@munted.org.uk are

fbdev-incorrect-url-given-in-drivers-video-kconfig.patch

