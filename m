From: akpm@linux-foundation.org
Subject: [merged] scsi-fix-convert-scsi_scanc-kernel-doc.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:10 -0400
Message-ID: <201005191732.o4JHWauI025748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab0ESRcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix/convert scsi_scan.c kernel-doc
has been removed from the -mm tree.  Its filename was
     scsi-fix-convert-scsi_scanc-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix/convert scsi_scan.c kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_scan.c: fix incorrectly formatted kernel-doc notation & convert
documentation of 2 functions into kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~scsi-fix-convert-scsi_scanc-kernel-doc drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-fix-convert-scsi_scanc-kernel-doc
+++ a/drivers/scsi/scsi_scan.c
@@ -1220,7 +1220,7 @@ static void scsi_sequential_lun_scan(str
 }
 
 /**
- * scsilun_to_int: convert a scsi_lun to an int
+ * scsilun_to_int - convert a scsi_lun to an int
  * @scsilun:	struct scsi_lun to be converted.
  *
  * Description:
@@ -1252,7 +1252,7 @@ int scsilun_to_int(struct scsi_lun *scsi
 EXPORT_SYMBOL(scsilun_to_int);
 
 /**
- * int_to_scsilun: reverts an int into a scsi_lun
+ * int_to_scsilun - reverts an int into a scsi_lun
  * @lun:        integer to be reverted
  * @scsilun:	struct scsi_lun to be set.
  *
@@ -1876,12 +1876,9 @@ void scsi_forget_host(struct Scsi_Host *
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-/*
- * Function:    scsi_get_host_dev()
- *
- * Purpose:     Create a scsi_device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a scsi_device
+/**
+ * scsi_get_host_dev - Create a scsi_device that points to the host adapter itself
+ * @shost: Host that needs a scsi_device
  *
  * Lock status: None assumed.
  *
@@ -1894,7 +1891,7 @@ void scsi_forget_host(struct Scsi_Host *
  *
  *	Note - this device is not accessible from any high-level
  *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach 
+ *	optimal.  We can add hooks later to attach.
  */
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
@@ -1920,18 +1917,13 @@ struct scsi_device *scsi_get_host_dev(st
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
 
-/*
- * Function:    scsi_free_host_dev()
- *
- * Purpose:     Free a scsi_device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a scsi_device
+/**
+ * scsi_free_host_dev - Free a scsi_device that points to the host adapter itself
+ * @sdev: Host device to be freed
  *
  * Lock status: None assumed.
  *
  * Returns:     Nothing
- *
- * Notes:
  */
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

