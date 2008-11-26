From: akpm@linux-foundation.org
Subject: - drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:04 -0800
Message-ID: <200811262046.mAQKk4Bi010590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbYKZUqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/pata_pdc2027x.c: cleanup kernel-doc
has been removed from the -mm tree.  Its filename was
     drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/ata/pata_pdc2027x.c: cleanup kernel-doc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

No argument named @pio in pdc2027x_set_piomode, and no argument named
@udma in pdc2027x_set_dmamode, remove them.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pdc2027x.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/ata/pata_pdc2027x.c~drivers-ata-pata_pdc2027xc-cleanup-kernel-doc drivers/ata/pata_pdc2027x.c
--- a/drivers/ata/pata_pdc2027x.c~drivers-ata-pata_pdc2027xc-cleanup-kernel-doc
+++ a/drivers/ata/pata_pdc2027x.c
@@ -281,7 +281,6 @@ static unsigned long pdc2027x_mode_filte
  *	pdc2027x_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port to configure
  *	@adev: um
- *	@pio: PIO mode, 0 - 4
  *
  *	Set PIO mode for device.
  *
@@ -326,7 +325,6 @@ static void pdc2027x_set_piomode(struct 
  *	pdc2027x_set_dmamode - Initialize host controller PATA UDMA timings
  *	@ap: Port to configure
  *	@adev: um
- *	@udma: udma mode, XFER_UDMA_0 to XFER_UDMA_6
  *
  *	Set UDMA mode for device.
  *
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

linux-next.patch
samples-mark-static__init__exit-for-initexit-functions.patch
fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

