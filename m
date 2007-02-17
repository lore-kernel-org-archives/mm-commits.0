From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-update-version-and-author-info.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:17:08 -0800
Message-ID: <200702170717.l1H7H8pQ021767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946539AbXBQHRM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sumantp@lsil.com, sumant.patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas - update version and author info
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-update-version-and-author-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: megaraid_sas - update version and author info
From: Sumant Patro <sumantp@lsil.com>

Update version and author information.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    8 +++++---
 drivers/scsi/megaraid/megaraid_sas.h |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-update-version-and-author-info drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-update-version-and-author-info
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -10,11 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.05
+ * Version	: v00.00.03.10-rc1
  *
  * Authors:
- * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsi.com>
- * 	Sumant Patro		<Sumant.Patro@lsi.com>
+ *	(email-id : megaraidlinux@lsi.com)
+ * 	Sreenivas Bagalkote
+ * 	Sumant Patro
+ *	Bo Yang
  *
  * List of supported controllers
  *
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-update-version-and-author-info drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-update-version-and-author-info
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.05"
-#define MEGASAS_RELDATE				"Oct 02, 2006"
-#define MEGASAS_EXT_VERSION			"Mon Oct 02 11:21:32 PDT 2006"
+#define MEGASAS_VERSION				"00.00.03.10-rc1"
+#define MEGASAS_RELDATE				"Feb 14, 2007"
+#define MEGASAS_EXT_VERSION			"Wed Feb 14 10:14:25 PST 2007"
 
 /*
  * Device IDs
_

Patches currently in -mm which might be from sumantp@lsil.com are

origin.patch
git-scsi-misc.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-return-sync-cache-call-with-success.patch
