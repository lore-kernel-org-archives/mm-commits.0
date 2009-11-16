From: akpm@linux-foundation.org
Subject: [folded] hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch removed from -mm tree
Date: Mon, 16 Nov 2009 13:28:12 -0800
Message-ID: <200911162128.nAGLSCZb000325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbZKPV2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 16:28:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: Allocate the correct amount of extra space for the scsi host
has been removed from the -mm tree.  Its filename was
     hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: Allocate the correct amount of extra space for the scsi host
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Allocate the correct amount of extra space for the scsi host

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host
+++ a/drivers/scsi/hpsa.c
@@ -890,7 +890,7 @@ static int hpsa_scsi_detect(struct ctlr_
 	struct Scsi_Host *sh;
 	int error;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(*h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
 	if (sh == NULL)
 		goto fail;
 
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch
hpsa-make-device-attrs-static.patch

