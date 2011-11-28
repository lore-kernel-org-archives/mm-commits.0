From: akpm@linux-foundation.org
Subject: [merged] drivers-edac-mpc85xx_edacc-fix-memory-controller-compatible-for-edac.patch removed from -mm tree
Date: Mon, 28 Nov 2011 13:01:42 -0800
Message-ID: <201111282101.pASL1gQa009544@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:34599 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1K1VBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 16:01:44 -0500
Received: by ggnp2 with SMTP id p2so573773ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 13:01:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Shaohui.Xie@freescale.com, benh@kernel.crashing.org, galak@kernel.crashing.org, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/edac/mpc85xx_edac.c: fix memory controller compatible for edac
has been removed from the -mm tree.  Its filename was
     drivers-edac-mpc85xx_edacc-fix-memory-controller-compatible-for-edac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: drivers/edac/mpc85xx_edac.c: fix memory controller compatible for edac

compatible in dts has been changed, so the driver needs to be updated
accordingly.

Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/mpc85xx_edac.c~drivers-edac-mpc85xx_edacc-fix-memory-controller-compatible-for-edac drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~drivers-edac-mpc85xx_edacc-fix-memory-controller-compatible-for-edac
+++ a/drivers/edac/mpc85xx_edac.c
@@ -1128,7 +1128,7 @@ static struct of_device_id mpc85xx_mc_er
 	{ .compatible = "fsl,p1020-memory-controller", },
 	{ .compatible = "fsl,p1021-memory-controller", },
 	{ .compatible = "fsl,p2020-memory-controller", },
-	{ .compatible = "fsl,p4080-memory-controller", },
+	{ .compatible = "fsl,qoriq-memory-controller", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mpc85xx_mc_err_of_match);
_

Patches currently in -mm which might be from Shaohui.Xie@freescale.com are

origin.patch

