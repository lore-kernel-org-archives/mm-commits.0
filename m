From: akpm@linux-foundation.org
Subject: + ibmpex-update-kconfig-to-list-more-supported-models.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:01:26 -0700
Message-ID: <200803132101.m2DL1QrG032671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022AbYCMVCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, mhoffman@lightlink.com


The patch titled
     ibmpex: update Kconfig to list more supported models
has been added to the -mm tree.  Its filename is
     ibmpex-update-kconfig-to-list-more-supported-models.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
scsi-aic94xx-cleanups.patch
ibmpex-correct-power-use-multipliers-for-qs2x-blade.patch
ibmpex-update-kconfig-to-list-more-supported-models.patch

