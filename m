From: akpm@linux-foundation.org
Subject: - alpm-increase-number-of-allowable-device-flags.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:33 -0700
Message-ID: <200708201912.l7KJCX39018360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760696AbXHTTVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ALPM: increase number of allowable device flags
has been removed from the -mm tree.  Its filename was
     alpm-increase-number-of-allowable-device-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALPM: increase number of allowable device flags
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/libata.h~alpm-increase-number-of-allowable-device-flags include/linux/libata.h
--- a/include/linux/libata.h~alpm-increase-number-of-allowable-device-flags
+++ a/include/linux/libata.h
@@ -139,7 +139,7 @@ enum {
 	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
 	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
git-libata-all.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
acpiphp_ibm-add-missing-n.patch
scsi-send-media-state-change-modification-events.patch
