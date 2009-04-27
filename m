From: akpm@linux-foundation.org
Subject: + documentation-fb-vesafbtxt-fix-typo.patch added to -mm tree
Date: Mon, 27 Apr 2009 12:02:55 -0700
Message-ID: <200904271902.n3RJ2t3C001503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837AbZD0TFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 15:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulepanter@users.sourceforge.net, kraxel@goldbach.in-berlin.de, schmoigl@rumms.uni-mannheim.de


The patch titled
     Documentation/fb/vesafb.txt: fix typo
has been added to the -mm tree.  Its filename is
     documentation-fb-vesafbtxt-fix-typo.patch

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
Subject: Documentation/fb/vesafb.txt: fix typo
From: Paul Menzel <paulepanter@users.sourceforge.net>

Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Gerd Knorr <kraxel@goldbach.in-berlin.de>
Cc: Nico Schmoigl <schmoigl@rumms.uni-mannheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/vesafb.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/fb/vesafb.txt~documentation-fb-vesafbtxt-fix-typo Documentation/fb/vesafb.txt
--- a/Documentation/fb/vesafb.txt~documentation-fb-vesafbtxt-fix-typo
+++ a/Documentation/fb/vesafb.txt
@@ -95,7 +95,7 @@ There is no way to change the vesafb vid
 booting linux.  If you are not happy with the 60 Hz refresh rate, you
 have these options:
 
- * configure and load the DOS-Tools for your the graphics board (if
+ * configure and load the DOS-Tools for the graphics board (if
    available) and boot linux with loadlin.
  * use a native driver (matroxfb/atyfb) instead if vesafb.  If none
    is available, write a new one!
_

Patches currently in -mm which might be from paulepanter@users.sourceforge.net are

documentation-fb-vesafbtxt-fix-typo.patch
fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb.patch

