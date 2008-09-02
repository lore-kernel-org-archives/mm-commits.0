From: akpm@linux-foundation.org
Subject: - scsi-select-crc_t10dif-only-when-necessary.patch removed from -mm tree
Date: Tue, 02 Sep 2008 12:48:32 -0700
Message-ID: <200809021948.m82JmWcQ009548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbYIBTsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 15:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefanr@s5r6.in-berlin.de, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scsi: select CRC_T10DIF only when necessary
has been removed from the -mm tree.  Its filename was
     scsi-select-crc_t10dif-only-when-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: select CRC_T10DIF only when necessary
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~scsi-select-crc_t10dif-only-when-necessary drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-select-crc_t10dif-only-when-necessary
+++ a/drivers/scsi/Kconfig
@@ -63,7 +63,7 @@ comment "SCSI support type (disk, tape, 
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
-	select CRC_T10DIF
+	select CRC_T10DIF if BLK_DEV_INTEGRITY
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

linux-next.patch
git-scsi-rc-fixes.patch

