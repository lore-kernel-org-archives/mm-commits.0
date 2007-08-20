From: akpm@linux-foundation.org
Subject: - enable-link-power-management-for-ata-drivers-fix.patch removed from -mm tree
Date: Mon, 20 Aug 2007 11:54:22 -0700
Message-ID: <200708201854.l7KIsMHq017533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbXHTSya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 14:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     Enable link power management for ata drivers (fix)
has been removed from the -mm tree.  Its filename was
     enable-link-power-management-for-ata-drivers-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Enable link power management for ata drivers (fix)
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

change to KERN_INFO for failure to set pm policy

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-scsi.c~enable-link-power-management-for-ata-drivers-fix drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~enable-link-power-management-for-ata-drivers-fix
+++ a/drivers/ata/libata-scsi.c
@@ -3006,7 +3006,7 @@ int ata_scsi_set_link_pm_policy(struct a
  		 */
 		if ((dev->horkage & ATA_HORKAGE_IPM) ||
 			!(dev->flags & ATA_DFLAG_IPM)) {
-			ata_dev_printk(dev, KERN_ERR,
+			ata_dev_printk(dev, KERN_INFO,
 				"Unable to set Link PM policy\n");
 			ap->pm_policy = MAX_PERFORMANCE;
 		}
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
git-libata-all.patch
enable-link-power-management-for-ata-drivers-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-check-for-an-support.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
libata-send-event-when-an-received.patch
acpiphp_ibm-add-missing-n.patch
scsi-send-media-state-change-modification-events.patch
