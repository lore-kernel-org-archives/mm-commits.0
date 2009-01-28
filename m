From: akpm@linux-foundation.org
Subject: + hpilo-increment-version.patch added to -mm tree
Date: Tue, 27 Jan 2009 17:04:37 -0800
Message-ID: <200901280104.n0S14bHq020661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbZA1BFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 20:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.altobelli@hp.com


The patch titled
     hpilo: increment version
has been added to the -mm tree.  Its filename is
     hpilo-increment-version.patch

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
Subject: hpilo: increment version
From: David Altobelli <david.altobelli@hp.com>

Bump hpilo module version to indicate that the open/close bug is fixed.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/hpilo.c~hpilo-increment-version drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-increment-version
+++ a/drivers/misc/hpilo.c
@@ -758,7 +758,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("0.05");
+MODULE_VERSION("0.06");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
_

Patches currently in -mm which might be from david.altobelli@hp.com are

hpilo-increment-version.patch
hpilo-open-close-fix.patch

