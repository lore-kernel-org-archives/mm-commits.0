From: akpm@linux-foundation.org
Subject: [folded] hpsa-make-hpsa_sdev_attrs-static.patch removed from -mm tree
Date: Mon, 16 Nov 2009 13:28:30 -0800
Message-ID: <200911162128.nAGLSUPX001070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123AbZKPV2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 16:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: Make hpsa_sdev_attrs static
has been removed from the -mm tree.  Its filename was
     hpsa-make-hpsa_sdev_attrs-static.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: Make hpsa_sdev_attrs static
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Make hpsa_sdev_attrs static

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-make-hpsa_sdev_attrs-static drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-make-hpsa_sdev_attrs-static
+++ a/drivers/scsi/hpsa.c
@@ -155,7 +155,7 @@ DEVICE_ATTR(lunid, S_IRUGO, lunid_show, 
 DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
-struct device_attribute *hpsa_sdev_attrs[] = {
+static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
 	&dev_attr_lunid,
 	&dev_attr_unique_id,
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch
hpsa-make-device-attrs-static.patch

