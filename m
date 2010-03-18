From: akpm@linux-foundation.org
Subject: [merged] isdn-misplaced-parenthesis-in-pof_handle_data.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:08:42 -0400
Message-ID: <201003181809.o2II9Npa007557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab0CRSJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     isdn: misplaced parenthesis in pof_handle_data()
has been removed from the -mm tree.  Its filename was
     isdn-misplaced-parenthesis-in-pof_handle_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: misplaced parenthesis in pof_handle_data()
From: Roel Kluin <roel.kluin@gmail.com>

The parenthesis was misplaced.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/hysdn_boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hysdn/hysdn_boot.c~isdn-misplaced-parenthesis-in-pof_handle_data drivers/isdn/hysdn/hysdn_boot.c
--- a/drivers/isdn/hysdn/hysdn_boot.c~isdn-misplaced-parenthesis-in-pof_handle_data
+++ a/drivers/isdn/hysdn/hysdn_boot.c
@@ -143,7 +143,7 @@ pof_handle_data(hysdn_card * card, int d
 					     (boot->pof_recid == TAG_CABSDATA) ? "CABSDATA" : "ABSDATA",
 					     datlen, boot->pof_recoffset);
 
-			if ((boot->last_error = card->writebootseq(card, boot->buf.BootBuf, datlen) < 0))
+			if ((boot->last_error = card->writebootseq(card, boot->buf.BootBuf, datlen)) < 0)
 				return (boot->last_error);	/* error writing data */
 
 			if (boot->pof_recoffset + datlen >= boot->pof_reclen)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

