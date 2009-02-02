From: akpm@linux-foundation.org
Subject: + mtd-remove-eol-from-module_description.patch added to -mm tree
Date: Mon, 02 Feb 2009 15:22:36 -0800
Message-ID: <200902022322.n12NMaCc025152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbZBBX0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 18:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: niels.devos@wincor-nixdorf.com, dwmw2@infradead.org


The patch titled
     MTD: remove EOL from MODULE_DESCRIPTION
has been added to the -mm tree.  Its filename is
     mtd-remove-eol-from-module_description.patch

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
Subject: MTD: remove EOL from MODULE_DESCRIPTION
From: Niels de Vos <niels.devos@wincor-nixdorf.com>

There is no need to have a "\n" on a MODULE_DESCRIPTION, remove it.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/diskonchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/diskonchip.c~mtd-remove-eol-from-module_description drivers/mtd/nand/diskonchip.c
--- a/drivers/mtd/nand/diskonchip.c~mtd-remove-eol-from-module_description
+++ a/drivers/mtd/nand/diskonchip.c
@@ -1773,4 +1773,4 @@ module_exit(cleanup_nanddoc);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium Plus device driver\n");
+MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium Plus device driver");
_

Patches currently in -mm which might be from niels.devos@wincor-nixdorf.com are

mtd-remove-eol-from-module_description.patch

