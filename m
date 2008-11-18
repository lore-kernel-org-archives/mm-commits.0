From: akpm@linux-foundation.org
Subject: + drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:34:46 -0800
Message-ID: <200811182334.mAINYkVI027806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbYKRXew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, randy.dunlap@oracle.com


The patch titled
     drivers/ata/pata_pdc2027x.c: cleanup kernel-doc
has been added to the -mm tree.  Its filename is
     drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

