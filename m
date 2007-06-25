From: akpm@linux-foundation.org
Subject: + libata-add-hts541616j9sa00-to-ncq-blacklist.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:47:21 -0700
Message-ID: <200706252247.l5PMlLZD012892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbXFYWrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, enricoss@tiscali.it


The patch titled
     libata: add HTS541616J9SA00 to NCQ blacklist
has been added to the -mm tree.  Its filename is
     libata-add-hts541616j9sa00-to-ncq-blacklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: add HTS541616J9SA00 to NCQ blacklist
From: Tejun Heo <htejun@gmail.com>

Another member of HTS5416* family doing spurious NCQ completion.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Enrico Sardi <enricoss@tiscali.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/libata-core.c~libata-add-hts541616j9sa00-to-ncq-blacklist drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-hts541616j9sa00-to-ncq-blacklist
+++ a/drivers/ata/libata-core.c
@@ -3809,6 +3809,7 @@ static const struct ata_blacklist_entry 
 	/* Drives which do spurious command completion */
 	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
 	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
+	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
pata_acpi-restore-driver.patch
libata-implement-ata_wait_after_reset.patch
libata-add-hts541616j9sa00-to-ncq-blacklist.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
git-scsi-misc.patch
update-documentation-block-barriertxt.patch
block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lib-add-idr_for_each.patch
lib-add-idr_for_each-fix.patch
lib-add-idr_remove_all.patch
