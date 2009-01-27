From: akpm@linux-foundation.org
Subject: + edac-remove-edacs-experimental-status.patch added to -mm tree
Date: Tue, 27 Jan 2009 13:40:43 -0800
Message-ID: <200901272140.n0RLehE5029681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbZA0Vl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 16:41:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     edac: remove EDAC's experimental status
has been added to the -mm tree.  Its filename is
     edac-remove-edacs-experimental-status.patch

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
Subject: edac: remove EDAC's experimental status
From: Doug Thompson <dougthompson@xmission.com>

After 3 years, this is a patch to remove the EXPERIMENTAL tag on EDAC.  We
now have many module drivers submitters in EDAC and believe EDAC is no
longer EXPERIMENTAL

Signed-off-by: Doug Thompson <dougthompson@xmission.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/edac/Kconfig~edac-remove-edacs-experimental-status drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-remove-edacs-experimental-status
+++ a/drivers/edac/Kconfig
@@ -1,13 +1,12 @@
 #
 #	EDAC Kconfig
-#	Copyright (c) 2003 Linux Networx
+#	Copyright (c) 2008 Doug Thompson www.softwarebitmaker.com
 #	Licensed and distributed under the GPL
 #
 
 menuconfig EDAC
-	bool "EDAC - error detection and reporting (EXPERIMENTAL)"
+	bool "EDAC - error detection and reporting"
 	depends on HAS_IOMEM
-	depends on EXPERIMENTAL
 	depends on X86 || PPC
 	help
 	  EDAC is designed to report errors in the core system.
_

Patches currently in -mm which might be from dougthompson@xmission.com are

linux-next.patch
edac-add-more-verbose-debug-info.patch
edac-remove-edacs-experimental-status.patch

