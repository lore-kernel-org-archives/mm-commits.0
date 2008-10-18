From: akpm@linux-foundation.org
Subject: - tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:38 -0700
Message-ID: <200810182319.m9INJcDH029525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYJRXUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     TPM: include "moderated for non-subscribers" notation in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4094,7 +4094,7 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
+L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 TRIVIAL PATCHES
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

origin.patch
tpm-dont-export-static-functions.patch

