From: akpm@linux-foundation.org
Subject: - docbook-fix-scsi-source-file.patch removed from -mm tree
Date: Mon, 03 Mar 2008 13:02:41 -0800
Message-ID: <200803032102.m23L2fsV006266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758748AbYCCVCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     docbook: fix scsi source file
has been removed from the -mm tree.  Its filename was
     docbook-fix-scsi-source-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix scsi source file
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problem in SCSI source files.  These cause the generated docbook
to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~docbook-fix-scsi-source-file drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~docbook-fix-scsi-source-file
+++ a/drivers/scsi/scsi_scan.c
@@ -1577,8 +1577,7 @@ static void __scsi_scan_target(struct de
 }
 
 /**
- * scsi_scan_target - scan a target id, possibly including all LUNs on the
- *     target.
+ * scsi_scan_target - scan a target id, possibly including all LUNs on the target.
  * @parent:	host to scan
  * @channel:	channel to scan
  * @id:		target id to scan
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kprobes-move-kprobe-examples-to-samples.patch
x86-visws-fix-printk-format-warnings.patch
apanel-fix-kconfig-dependencies.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
profile-likely-unlikely-macros.patch

