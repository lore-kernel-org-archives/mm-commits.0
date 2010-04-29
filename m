From: akpm@linux-foundation.org
Subject: [merged] vt6655-cgi-csi-confusion-in-device_ioctl.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:56:58 -0400
Message-ID: <201004292058.o3TKwU4B011795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932752Ab0D3RJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     vt6655: CGI/CSI confusion in device_ioctl()
has been removed from the -mm tree.  Its filename was
     vt6655-cgi-csi-confusion-in-device_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt6655: CGI/CSI confusion in device_ioctl()
From: Roel Kluin <roel.kluin@gmail.com>

The wrong messages were printed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/vt6655/device_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/staging/vt6655/device_main.c~vt6655-cgi-csi-confusion-in-device_ioctl drivers/staging/vt6655/device_main.c
--- a/drivers/staging/vt6655/device_main.c~vt6655-cgi-csi-confusion-in-device_ioctl
+++ a/drivers/staging/vt6655/device_main.c
@@ -3328,7 +3328,7 @@ static int  device_ioctl(struct net_devi
 		break;
 
 	case SIOCSIWTXPOW:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW \n");
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWTXPOW \n");
         rc = -EOPNOTSUPP;
 		break;
 
@@ -3406,7 +3406,7 @@ static int  device_ioctl(struct net_devi
 		// Get the spy list
 	case SIOCGIWSPY:
 
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY \n");
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSPY \n");
 		rc = -EOPNOTSUPP;
 		break;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hvsi-messed-up-error-checking-getting-state-name.patch

