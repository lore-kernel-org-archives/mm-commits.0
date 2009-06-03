From: akpm@linux-foundation.org
Subject: + edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch added to -mm tree
Date: Wed, 03 Jun 2009 14:34:28 -0700
Message-ID: <200906032134.n53LYSFx008547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118AbZFCVeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 17:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leemgs1@gmail.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, geunsik.lim@samsung.com


The patch titled
     edac: Kconfig: fix the meaning of EDAC abbreviation
has been added to the -mm tree.  Its filename is
     edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch

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
Subject: edac: Kconfig: fix the meaning of EDAC abbreviation
From: GeunSik Lim <leemgs1@gmail.com>

Fix the meaning of EDAC(Error Detection And Correction) correctly.

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/Kconfig~edac-kconfig-fix-the-meaning-of-edac-abbreviation drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-kconfig-fix-the-meaning-of-edac-abbreviation
+++ a/drivers/edac/Kconfig
@@ -5,7 +5,7 @@
 #
 
 menuconfig EDAC
-	bool "EDAC - error detection and reporting"
+	bool "EDAC(Error Detection And Correction) reporting"
 	depends on HAS_IOMEM
 	depends on X86 || PPC
 	help
_

Patches currently in -mm which might be from leemgs1@gmail.com are

linux-next.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch

