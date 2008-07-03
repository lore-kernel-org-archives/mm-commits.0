From: akpm@linux-foundation.org
Subject: + update-maintainers-file-for-the-tpm-device-driver.patch added to -mm tree
Date: Thu, 03 Jul 2008 15:45:36 -0700
Message-ID: <200807032245.m63Mja60031281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbYGCWpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 18:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com


The patch titled
     Update MAINTAINERS file for the TPM device driver
has been added to the -mm tree.  Its filename is
     update-maintainers-file-for-the-tpm-device-driver.patch

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
Subject: Update MAINTAINERS file for the TPM device driver
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Acked-By: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~update-maintainers-file-for-the-tpm-device-driver MAINTAINERS
--- a/MAINTAINERS~update-maintainers-file-for-the-tpm-device-driver
+++ a/MAINTAINERS
@@ -4013,7 +4013,8 @@ W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
 
 TPM DEVICE DRIVER
-P:	Kylene Hall
+P:     Debora Velarde
+P:     Rajiv Andrade
 M:	tpmdd-devel@lists.sourceforge.net
 W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

update-maintainers-file-for-the-tpm-device-driver.patch

