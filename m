From: akpm@linux-foundation.org
Subject: + msi-laptop-change-driver-maintainer-to-lee-chun-yi.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:29:08 -0700
Message-ID: <201009102329.o8ANT8ta009264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab0IJX34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:29:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joeyli.kernel@gmail.com, jlee@novell.com, mjg@redhat.com, mzxreary@0pointer.de


The patch titled
     msi-laptop: change driver maintainer to Lee, Chun-Yi
has been added to the -mm tree.  Its filename is
     msi-laptop-change-driver-maintainer-to-lee-chun-yi.patch

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
Subject: msi-laptop: change driver maintainer to Lee, Chun-Yi
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

Change MSI LAPTOP driver maintainer from Lennart Poettering to Lee, Chun-Yi.

MSI is a Taiwan OEM company, Lee, Chun-Yi can more easy to contact with
MSI and maintain msi-laptop driver.  Thank's for Lennart Poettering's
contribute, Lee, Chun-Yi will base on his article to continue maintain the
msi-laptop driver.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~msi-laptop-change-driver-maintainer-to-lee-chun-yi MAINTAINERS
--- a/MAINTAINERS~msi-laptop-change-driver-maintainer-to-lee-chun-yi
+++ a/MAINTAINERS
@@ -3916,10 +3916,8 @@ F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
-M:	Lennart Poettering <mzxreary@0pointer.de>
+M:	Lee, Chun-Yi <jlee@novell.com>
 L:	platform-driver-x86@vger.kernel.org
-W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
-W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
 
_

Patches currently in -mm which might be from joeyli.kernel@gmail.com are

msi-laptop-change-driver-maintainer-to-lee-chun-yi.patch

