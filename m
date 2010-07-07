From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch added to -mm tree
Date: Wed, 07 Jul 2010 14:45:22 -0700
Message-ID: <201007072145.o67LjMoQ028427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab0GGVtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 17:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, djiang@mvista.com, dougthompson@xmission.com, galak@kernel.crashing.org, ptyser@xes-inc.com


The patch titled
     edac: mpc85xx: add support for MPC8569 EDAC controllers
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch

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
Subject: edac: mpc85xx: add support for MPC8569 EDAC controllers
From: Anton Vorontsov <avorontsov@mvista.com>

Simply add a proper ID into the device table.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Dave Jiang <djiang@mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-mpc8569-edac-controllers drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-mpc8569-edac-controllers
+++ a/drivers/edac/mpc85xx_edac.c
@@ -1120,6 +1120,7 @@ static struct of_device_id mpc85xx_mc_er
 	{ .compatible = "fsl,mpc8555-memory-controller", },
 	{ .compatible = "fsl,mpc8560-memory-controller", },
 	{ .compatible = "fsl,mpc8568-memory-controller", },
+	{ .compatible = "fsl,mpc8569-memory-controller", },
 	{ .compatible = "fsl,mpc8572-memory-controller", },
 	{ .compatible = "fsl,mpc8349-memory-controller", },
 	{ .compatible = "fsl,p2020-memory-controller", },
_

Patches currently in -mm which might be from avorontsov@mvista.com are

edac-mpc85xx-fix-mpc85xx-dependency.patch
edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch
linux-next.patch
sdhci-pltfm-switch-to-module-device-table-matching.patch
sdhci-pltfm-reorganize-makefile-entries-to-support-soc-devices.patch
sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch

