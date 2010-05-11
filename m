From: akpm@linux-foundation.org
Subject: [merged] mtd-nandsim-fix-typo-struct-nandsin_geometry.patch removed from -mm tree
Date: Tue, 11 May 2010 12:17:04 -0400
Message-ID: <201005111918.o4BJIWxN018213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525Ab0EKTSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wferi@niif.hu, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: nandsim: fix typo: struct nandsin_geometry
has been removed from the -mm tree.  Its filename was
     mtd-nandsim-fix-typo-struct-nandsin_geometry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

