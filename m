From: akpm@linux-foundation.org
Subject: - rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:17 -0700
Message-ID: <200804300551.m3U5pHfQ030209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759221AbYD3FvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: add RapidIO node probing into MPC86xx_HPCN board id table
has been removed from the -mm tree.  Its filename was
     rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add RapidIO node probing into MPC86xx_HPCN board id table
From: Zhang Wei <wei.zhang@freescale.com>

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/platforms/86xx/mpc86xx_hpcn.c~rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c~rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table
+++ a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -215,6 +215,7 @@ mpc86xx_time_init(void)
 
 static __initdata struct of_device_id of_bus_ids[] = {
 	{ .compatible = "simple-bus", },
+	{ .compatible = "fsl,rapidio-delta", },
 	{},
 };
 
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

