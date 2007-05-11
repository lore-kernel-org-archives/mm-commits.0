From: akpm@linux-foundation.org
Subject: - libata-check-for-an-support-update.patch removed from -mm tree
Date: Thu, 10 May 2007 22:46:52 -0700
Message-ID: <200705110546.l4B5kqsB007590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbXEKFqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 01:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     libata-check-for-an-support update
has been removed from the -mm tree.  Its filename was
     libata-check-for-an-support-update.patch

This patch was dropped because it was folded into libata-check-for-an-support.patch

------------------------------------------------------
Subject: libata-check-for-an-support update
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Andrew, I cleaned up the function header to properly comply with kernel
doc requirements.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-check-for-an-support-update drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-check-for-an-support-update
+++ a/drivers/ata/libata-core.c
@@ -3915,12 +3915,11 @@ static unsigned int ata_dev_set_xfermode
 
 /**
  *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
- *                       with sector count set to indicate
- *                       Asynchronous Notification feature
  *	@dev: Device to which command will be sent
  *
  *	Issue SET FEATURES - SATA FEATURES command to device @dev
- *	on port @ap.
+ *	on port @ap with sector count set to indicate Asynchronous
+ *	Notification feature
  *
  *	LOCKING:
  *	PCI/etc. bus probe sem.
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
git-acpi.patch
libata-check-for-an-support.patch
libata-check-for-an-support-update.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
