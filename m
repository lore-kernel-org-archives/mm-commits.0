From: akpm@linux-foundation.org
Subject: - adaptec-maintainers-updates.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:03 -0700
Message-ID: <200703292337.l2TNb3LB015069@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934378AbXC2XhJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark_salyzyn@adaptec.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     adaptec MAINTAINERS updates
has been removed from the -mm tree.  Its filename was
     adaptec-maintainers-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 16 insertions(+), 1 deletion(-)

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

origin.patch
git-scsi-misc.patch
drivers-scsi-aacraid-cleanups.patch
