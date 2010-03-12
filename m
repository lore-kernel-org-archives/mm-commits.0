From: akpm@linux-foundation.org
Subject: + mtd-nand-remove-stray-endchoice-from-kconfig-help-text.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:57:24 -0800
Message-ID: <201003122257.o2CMvO1x012874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205Ab0CLW5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wferi@niif.hu, dwmw2@infradead.org


The patch titled
     mtd: nand: remove stray endchoice from Kconfig help text
has been added to the -mm tree.  Its filename is
     mtd-nand-remove-stray-endchoice-from-kconfig-help-text.patch

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
Subject: mtd: nand: remove stray endchoice from Kconfig help text
From: Ferenc Wagner <wferi@niif.hu>

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mtd/nand/Kconfig~mtd-nand-remove-stray-endchoice-from-kconfig-help-text drivers/mtd/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~mtd-nand-remove-stray-endchoice-from-kconfig-help-text
+++ a/drivers/mtd/nand/Kconfig
@@ -368,8 +368,6 @@ config MTD_NAND_ATMEL_ECC_NONE
 
 	  If unsure, say N
 
-	  endchoice
