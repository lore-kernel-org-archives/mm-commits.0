From: akpm@linux-foundation.org
Subject: + maintainers-remove-section-usb-se401-driver.patch added to -mm tree
Date: Mon, 20 Jun 2011 16:34:44 -0700
Message-ID: <201106202334.p5KNYiKi030020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151Ab1FTXet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 19:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, hverkuil@xs4all.nl, mchehab@redhat.com


The patch titled
     MAINTAINERS: uemove section USB SE401 DRIVER
has been added to the -mm tree.  Its filename is
     maintainers-remove-section-usb-se401-driver.patch

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
Subject: MAINTAINERS: uemove section USB SE401 DRIVER
From: Joe Perches <joe@perches.com>

Commit b287db119edb ("[media] se401: remove last V4L1 driver")
removed the driver, so remove the section from MAINTAINERS.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 -------
 1 file changed, 7 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-section-usb-se401-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-section-usb-se401-driver
+++ a/MAINTAINERS
@@ -6545,13 +6545,6 @@ W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
-USB SE401 DRIVER
-L:	linux-usb@vger.kernel.org
-W:	http://www.chello.nl/~j.vreeken/se401/
-S:	Orphan
-F:	Documentation/video4linux/se401.txt
-F:	drivers/staging/se401/
