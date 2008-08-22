From: akpm@linux-foundation.org
Subject: + maintainers-add-a-maintainer-for-the-bcm5974-multitouch-driver.patch added to -mm tree
Date: Fri, 22 Aug 2008 11:57:08 -0700
Message-ID: <200808221857.m7MIv8qu011091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbYHVS5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 14:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, dtor@mail.ru


The patch titled
     MAINTAINERS: add a maintainer for the BCM5974 multitouch driver
has been added to the -mm tree.  Its filename is
     maintainers-add-a-maintainer-for-the-bcm5974-multitouch-driver.patch

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
Subject: MAINTAINERS: add a maintainer for the BCM5974 multitouch driver
From: Henrik Rydberg <rydberg@euromail.se>

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-a-maintainer-for-the-bcm5974-multitouch-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-a-maintainer-for-the-bcm5974-multitouch-driver
+++ a/MAINTAINERS
@@ -424,6 +424,12 @@ L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported
 
+APPLE BCM5974 MULTITOUCH DRIVER
+P:	Henrik Rydberg
+M:	rydberg@euromail.se
+L:	linux-input@vger.kernel.org
+S:	Maintained
+
 APPLE SMC DRIVER
 P:	Nicolas Boichat
 M:	nicolas@boichat.ch
_

Patches currently in -mm which might be from rydberg@euromail.se are

maintainers-add-a-maintainer-for-the-bcm5974-multitouch-driver.patch

