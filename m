From: akpm@linux-foundation.org
Subject: - scsi-ioctl-fix-kernel-doc-warning.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:18 -0800
Message-ID: <200811102034.mAAKYIRs024978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbYKJUe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi ioctl: fix kernel-doc warning
has been removed from the -mm tree.  Its filename was
     scsi-ioctl-fix-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi ioctl: fix kernel-doc warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc parameter warning and correct the function name:

Warning(linux-next-20081022//drivers/scsi/scsi_ioctl.c:281): No description found for parameter 'ndelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_ioctl.c~scsi-ioctl-fix-kernel-doc-warning drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c~scsi-ioctl-fix-kernel-doc-warning
+++ a/drivers/scsi/scsi_ioctl.c
@@ -270,11 +270,11 @@ int scsi_ioctl(struct scsi_device *sdev,
 EXPORT_SYMBOL(scsi_ioctl);
 
 /**
- * scsi_nonblock_ioctl() - Handle SG_SCSI_RESET
+ * scsi_nonblockable_ioctl() - Handle SG_SCSI_RESET
  * @sdev: scsi device receiving ioctl
  * @cmd: Must be SC_SCSI_RESET
  * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,BUS,HOST}
- * @filp: either NULL or a &struct file which must have the O_NONBLOCK flag.
+ * @ndelay: file mode O_NDELAY flag
  */
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, int ndelay)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
doc-add-printk-formatstxt.patch
doc-add-printk-formatstxt-fix.patch
doc-update-xip-method-info.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

