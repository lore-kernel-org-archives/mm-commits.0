From: akpm@linux-foundation.org
Subject: - drivers-ata-pata_sisc-cleanup-kernel-doc.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:08 -0800
Message-ID: <200811262046.mAQKk8Zf010597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbYKZU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:56:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/pata_sis.c: cleanup kernel-doc
has been removed from the -mm tree.  Its filename was
     drivers-ata-pata_sisc-cleanup-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/ata/pata_sis.c: cleanup kernel-doc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

No argument named @deadline in sis_66_cable_detect, remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/ata/pata_sis.c~drivers-ata-pata_sisc-cleanup-kernel-doc drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~drivers-ata-pata_sisc-cleanup-kernel-doc
+++ a/drivers/ata/pata_sis.c
@@ -113,7 +113,6 @@ static int sis_133_cable_detect(struct a
 /**
  *	sis_66_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

linux-next.patch
samples-mark-static__init__exit-for-initexit-functions.patch
fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

