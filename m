From: akpm@linux-foundation.org
Subject: - drivers-edac-mpc85xx-add-static-scope.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:03 -0800
Message-ID: <200802080805.m1885iRD014372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758451AbYBHITS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: mpc85xx: add static scope
has been removed from the -mm tree.  Its filename was
     drivers-edac-mpc85xx-add-static-scope.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/edac: mpc85xx: add static scope
From: Doug Thompson <dougthompson@xmission.com>

Made a previous global variable, static in scope

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/mpc85xx_edac.c~drivers-edac-mpc85xx-add-static-scope drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~drivers-edac-mpc85xx-add-static-scope
+++ a/drivers/edac/mpc85xx_edac.c
@@ -43,7 +43,7 @@ static u32 orig_pci_err_en;
 static u32 orig_l2_err_disable;
 static u32 orig_hid1;
 
-const char *mpc85xx_ctl_name = "MPC85xx";
+static const char *mpc85xx_ctl_name = "MPC85xx";
 
 /************************ MC SYSFS parts ***********************************/
 
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
