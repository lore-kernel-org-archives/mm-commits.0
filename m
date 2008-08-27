From: akpm@linux-foundation.org
Subject: + tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch added to -mm tree
Date: Tue, 26 Aug 2008 17:53:36 -0700
Message-ID: <200808270053.m7R0raGq004181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbYH0Ayc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 20:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, eparis@redhat.com


The patch titled
     TPM: include "moderated for non-subscribers" notation in MAINTAINERS
has been added to the -mm tree.  Its filename is
     tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch

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
Subject: TPM: include "moderated for non-subscribers" notation in MAINTAINERS
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~tpm-include-moderated-for-non-subscribers-notation-in-maintainers MAINTAINERS
--- a/MAINTAINERS~tpm-include-moderated-for-non-subscribers-notation-in-maintainers
+++ a/MAINTAINERS
@@ -4098,7 +4098,7 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
+L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 TRIVIAL PATCHES
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

securityfs-do-not-depend-on-config_security.patch
tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch

