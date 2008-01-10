From: akpm@linux-foundation.org
Subject: + drivers-edac-mpc85xx-add-static-scope.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:28:27 -0800
Message-ID: <200801100528.m0A5S7Fw006791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbYAJF2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:28:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers/edac: mpc85xx: add static scope
has been added to the -mm tree.  Its filename is
     drivers-edac-mpc85xx-add-static-scope.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-powerpc.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
drivers-edac-i3000-64bit-build.patch
drivers-edac-mpc85xx-add-static-scope.patch
