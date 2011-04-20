From: akpm@linux-foundation.org
Subject: + maintainers-update-documentation-file-entry-of-gpio-subsystem.patch added to -mm tree
Date: Wed, 20 Apr 2011 15:36:42 -0700
Message-ID: <201104202236.p3KMag1d031279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab1DTWgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 18:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kgene.kim@samsung.com, grant.likely@secretlab.ca


The patch titled
     MAINTAINERS: update Documentation file entry of GPIO subsystem
has been added to the -mm tree.  Its filename is
     maintainers-update-documentation-file-entry-of-gpio-subsystem.patch

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
Subject: MAINTAINERS: update Documentation file entry of GPIO subsystem
From: Kukjin Kim <kgene.kim@samsung.com>

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-documentation-file-entry-of-gpio-subsystem MAINTAINERS
--- a/MAINTAINERS~maintainers-update-documentation-file-entry-of-gpio-subsystem
+++ a/MAINTAINERS
@@ -2820,7 +2820,7 @@ GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
 S:	Maintained
 T:	git git://git.secretlab.ca/git/linux-2.6.git
-F:	Documentation/gpio/gpio.txt
+F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
 
_

Patches currently in -mm which might be from kgene.kim@samsung.com are

linux-next.patch
maintainers-update-documentation-file-entry-of-gpio-subsystem.patch

