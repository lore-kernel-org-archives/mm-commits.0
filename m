From: akpm@linux-foundation.org
Subject: + mtd-nandsim-fix-typo-struct-nandsin_geometry.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:56:40 -0800
Message-ID: <201003122256.o2CMueGY012830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933350Ab0CLW47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:56:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wferi@niif.hu, dwmw2@infradead.org


The patch titled
     mtd: nandsim: fix typo: struct nandsin_geometry
has been added to the -mm tree.  Its filename is
     mtd-nandsim-fix-typo-struct-nandsin_geometry.patch

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
Subject: mtd: nandsim: fix typo: struct nandsin_geometry
From: Ferenc Wagner <wferi@niif.hu>

The name was spelled wrong.  We don't need an identifier on this struct
anyway, so remove it altogether.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nandsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/nandsim.c~mtd-nandsim-fix-typo-struct-nandsin_geometry drivers/mtd/nand/nandsim.c
--- a/drivers/mtd/nand/nandsim.c~mtd-nandsim-fix-typo-struct-nandsin_geometry
+++ a/drivers/mtd/nand/nandsim.c
@@ -315,7 +315,7 @@ struct nandsim {
 	union ns_mem buf;
 
 	/* NAND flash "geometry" */
-	struct nandsin_geometry {
+	struct {
 		uint64_t totsz;     /* total flash size, bytes */
 		uint32_t secsz;     /* flash sector (erase block) size, bytes */
 		uint pgsz;          /* NAND flash page size, bytes */
_

Patches currently in -mm which might be from wferi@niif.hu are

mtd-nandsim-fix-typo-struct-nandsin_geometry.patch

