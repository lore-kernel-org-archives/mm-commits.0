From: akpm@linux-foundation.org
Subject: + docbook-fix-scsi-source-file.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:23:34 -0800
Message-ID: <200803030723.m237NYjR004393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbYCCHXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:23:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com


The patch titled
     docbook: fix scsi source file
has been added to the -mm tree.  Its filename is
     docbook-fix-scsi-source-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
docbook-fix-filesystemstmpl-source-files.patch
docbook-fix-rapidio-source-files.patch
docbook-fix-scsi-source-file.patch
docbook-fix-kernel-api-source-files.patch
docbook-fix-fusion-source-files.patch

