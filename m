From: akpm@linux-foundation.org
Subject: - libata-add-hts541616j9sa00-to-ncq-blacklist.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:16:45 -0700
Message-ID: <200707022016.l62KGjE1004803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34791 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754156AbXGBURZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:17:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, enricoss@tiscali.it, mm-commits@vger.kernel.org


The patch titled
     libata: add HTS541616J9SA00 to NCQ blacklist
has been removed from the -mm tree.  Its filename was
     libata-add-hts541616j9sa00-to-ncq-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
sata_promise-cleanups.patch
sata_promise-sata-hotplug-support.patch
libata-add-irq_flags-to-struct-pata_platform_info.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-scsi-misc.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
git-block.patch
update-documentation-block-barriertxt.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lib-add-idr_for_each.patch
lib-add-idr_for_each-fix.patch
lib-add-idr_remove_all.patch
