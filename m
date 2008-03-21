From: akpm@linux-foundation.org
Subject: - ibmpex-update-kconfig-to-list-more-supported-models.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:19 -0700
Message-ID: <200803212029.m2LKTJgB008856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759010AbYCUU37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     ibmpex: update Kconfig to list more supported models
has been removed from the -mm tree.  Its filename was
     ibmpex-update-kconfig-to-list-more-supported-models.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmpex: update Kconfig to list more supported models
From: "Darrick J. Wong" <djwong@us.ibm.com>

Enhanced the list of supported machines.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/Kconfig~ibmpex-update-kconfig-to-list-more-supported-models drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~ibmpex-update-kconfig-to-list-more-supported-models
+++ a/drivers/hwmon/Kconfig
@@ -337,8 +337,9 @@ config SENSORS_IBMPEX
 	help
 	  If you say yes here you get support for the temperature and
 	  power sensors in various IBM System X servers that support
-	  PowerExecutive.  So far this includes the x3550, x3650, x3655,
-	  x3755, and certain HS20 blades.
+	  PowerExecutive.  So far this includes the x3350, x3550, x3650,
+	  x3655, and x3755; the x3800, x3850, and x3950 models that have
+	  PCI Express; and some of the HS2x, LS2x, and QS2x blades.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called ibmpex.
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
git-hwmon.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
scsi-aic94xx-cleanups.patch

