From: akpm@linux-foundation.org
Subject: - atl1-fix-typo-in-dma_req_block.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:20 -0700
Message-ID: <200707242325.l6ONPKjO006355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757052AbXGXXgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: fix typo in dma_req_block
has been removed from the -mm tree.  Its filename was
     atl1-fix-typo-in-dma_req_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-netdev-all.patch
