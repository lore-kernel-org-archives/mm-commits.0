From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-version-and-documentation-update.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:41:15 -0700
Message-ID: <200808181941.m7IJfFnr008531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934269AbYHRTuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, bo.yang@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas: version and Documentation Update
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-version-and-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: megaraid_sas: version and Documentation Update
From: "Yang, Bo" <Bo.Yang@lsi.com>

Update the Version and Documentation.

Signed-off-by: Bo Yang<bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.megaraid_sas |   23 ++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h      |    6 ++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff -puN Documentation/scsi/ChangeLog.megaraid_sas~scsi-megaraid_sas-version-and-documentation-update Documentation/scsi/ChangeLog.megaraid_sas
--- a/Documentation/scsi/ChangeLog.megaraid_sas~scsi-megaraid_sas-version-and-documentation-update
+++ a/Documentation/scsi/ChangeLog.megaraid_sas
@@ -1,3 +1,26 @@
+
+1 Release Date    : Thur.July. 24 11:41:51 PST 2008 -
+                       (emaild-id:megaraidlinux@lsi.com)
+                       Sumant Patro
+                       Bo Yang
+
+2 Current Version : 00.00.04.01
+3 Older Version   : 00.00.03.22
+
+1. Add the new controller (0078, 0079) support to the driver
+       Those controllers are LSI's next generatation(gen2) SAS controllers.
+
+1 Release Date    : Mon.June. 23 10:12:45 PST 2008 -
+                       (emaild-id:megaraidlinux@lsi.com)
+                       Sumant Patro
+                       Bo Yang
+
+2 Current Version : 00.00.03.22
+3 Older Version   : 00.00.03.20
+
+1. Add shutdown DCMD cmd to the shutdown routine to make FW shutdown proper.
+2. Unexpected interrupt occurs in HWR Linux driver, add the dumy readl pci flush will fix this issue.
+
 1 Release Date    : Mon. March 10 11:02:31 PDT 2008 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Sumant Patro
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-version-and-documentation-update drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-version-and-documentation-update
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION			"00.00.03.20-rc1"
-#define MEGASAS_RELDATE			"March 10, 2008"
-#define MEGASAS_EXT_VERSION		"Mon. March 10 11:02:31 PDT 2008"
+#define MEGASAS_VERSION				"00.00.04.01"
+#define MEGASAS_RELDATE				"July 24, 2008"
+#define MEGASAS_EXT_VERSION			"Thu July 24 11:41:51 PST 2008"
 
 /*
  * Device IDs
_

Patches currently in -mm which might be from Bo.Yang@lsi.com are

linux-next.patch
drivers-scsi-megaraid-use-div_round_up.patch

