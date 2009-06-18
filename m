From: akpm@linux-foundation.org
Subject: [merged] edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:57 -0700
Message-ID: <200906182247.n5IMlvgE006996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938AbZFRWsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leemgs1@gmail.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, geunsik.lim@samsung.com, mm-commits@vger.kernel.org


The patch titled
     edac: Kconfig: fix the meaning of EDAC abbreviation
has been removed from the -mm tree.  Its filename was
     edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: Kconfig: fix the meaning of EDAC abbreviation
From: GeunSik Lim <leemgs1@gmail.com>

Fix the meaning of EDAC(Error Detection And Correction) correctly.

[akpm@linux-foundation.org: add missing space]
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
+	bool "EDAC (Error Detection And Correction) reporting"
 	depends on HAS_IOMEM
 	depends on X86 || PPC
 	help
_

Patches currently in -mm which might be from leemgs1@gmail.com are

origin.patch
linux-next.patch

