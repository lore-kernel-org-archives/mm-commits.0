From: akpm@linux-foundation.org
Subject: + drivers-edac-mpc85xx_edacc-fix-memory-controller-compatible-for-edac.patch added to -mm tree
Date: Mon, 29 Aug 2011 16:47:20 -0700
Message-ID: <201108292347.p7TNlKlF011004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab1H2Xry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 19:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Shaohui.Xie@freescale.com, benh@kernel.crashing.org, galak@kernel.crashing.org, grant.likely@secretlab.ca


The patch titled
     drivers/edac/mpc85xx_edac.c: fix memory controller compatible for edac
has been added to the -mm tree.  Its filename is
     drivers-edac-mpc85xx_edacc-fix-memory-controller-compatible-for-edac.patch

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
Subject: drivers/edac/mpc85xx_edac.c: fix memory controller compatible for edac
From: Shaohui Xie <Shaohui.Xie@freescale.com>

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

drivers-edac-mpc85xx_edacc-fix-memory-controller-compatible-for-edac.patch

