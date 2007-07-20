From: akpm@linux-foundation.org
Subject: + atl1-fix-typo-in-dma_req_block.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:45:19 -0700
Message-ID: <200707202145.l6KLjJv5018085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757262AbXGTVp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net


The patch titled
     atl1: fix typo in dma_req_block
has been added to the -mm tree.  Its filename is
     atl1-fix-typo-in-dma_req_block.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atl1: fix typo in dma_req_block
From: Jay Cliburn <jacliburn@bellsouth.net>

s/dam/dma

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_hw.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/atl1/atl1_hw.h~atl1-fix-typo-in-dma_req_block drivers/net/atl1/atl1_hw.h
--- a/drivers/net/atl1/atl1_hw.h~atl1-fix-typo-in-dma_req_block
+++ a/drivers/net/atl1/atl1_hw.h
@@ -929,8 +929,8 @@ enum atl1_dma_req_block {
 	atl1_dma_req_128 = 0,
 	atl1_dma_req_256 = 1,
 	atl1_dma_req_512 = 2,
-	atl1_dam_req_1024 = 3,
-	atl1_dam_req_2048 = 4,
+	atl1_dma_req_1024 = 3,
+	atl1_dma_req_2048 = 4,
 	atl1_dma_req_4096 = 5
 };
 
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
atl1-change-tpd_avail-function-name.patch
atl1-fix-typo-in-dma-engine-setup.patch
atl1-change-cmb-write-threshold.patch
atl1-fix-typo-in-dma_req_block.patch
atl1-use-kernel-provided-ethernet-length-constants.patch
