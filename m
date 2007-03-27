From: akpm@linux-foundation.org
Subject: + adaptec-maintainers-updates.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:39:49 -0700
Message-ID: <200703272039.l2RKdnxD027207@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965412AbXC0Ujz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark_salyzyn@adaptec.com, James.Bottomley@steeleye.com


The patch titled
     adaptec MAINTAINERS updates
has been added to the -mm tree.  Its filename is
     adaptec-maintainers-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: adaptec MAINTAINERS updates
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

The IPS and DPT_I2O drivers are missing, so here is my 'hand coded'
addition to deal with overlap to the patch below (apply both). I
selected Maintained rather than supported for the ips and dpt_i2o driver
due to their legacy nature.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~adaptec-maintainers-updates MAINTAINERS
--- a/MAINTAINERS~adaptec-maintainers-updates
+++ a/MAINTAINERS
@@ -198,10 +198,25 @@ L:	linux-sound@vger.kernel.org
 W:	http://www.stud.uni-karlsruhe.de/~uh1b/
 S:	Maintained
 
+IPS SCSI RAID DRIVER
+P:	Adaptec OEM Raid Solutions
+M:	aacraid@adaptec.com
+L:	linux-scsi@vger.kernel.org
+W:	http://www.adaptec.com/
+S:	Maintained
+
+DPT_I2O SCSI RAID DRIVER
+P:	Adaptec OEM Raid Solutions
+M:	aacraid@adaptec.com
+L:	linux-scsi@vger.kernel.org
+W:	http://www.adaptec.com/
+S:	Maintained
+
 AACRAID SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
+M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
-W:	http://linux.dell.com/storage.shtml
+W:	http://www.adaptec.com/
 S:	Supported
 
 ACPI
_

Patches currently in -mm which might be from mark_salyzyn@adaptec.com are

adaptec-maintainers-updates.patch
git-scsi-misc.patch
drivers-scsi-aacraid-cleanups.patch
