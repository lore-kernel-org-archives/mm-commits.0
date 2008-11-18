From: akpm@linux-foundation.org
Subject: + drivers-ata-pata_radisysc-cleanup-kernel-doc.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:34:38 -0800
Message-ID: <200811182334.mAINYc3v027717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbYKRXep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, randy.dunlap@oracle.com


The patch titled
     drivers/ata/pata_radisys.c: cleanup kernel-doc
has been added to the -mm tree.  Its filename is
     drivers-ata-pata_radisysc-cleanup-kernel-doc.patch

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
Subject: drivers/ata/pata_radisys.c: cleanup kernel-doc
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

No argument named @isich in radisys_set_dmamode, remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_radisys.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/ata/pata_radisys.c~drivers-ata-pata_radisysc-cleanup-kernel-doc drivers/ata/pata_radisys.c
--- a/drivers/ata/pata_radisys.c~drivers-ata-pata_radisysc-cleanup-kernel-doc
+++ a/drivers/ata/pata_radisys.c
@@ -81,7 +81,6 @@ static void radisys_set_piomode (struct 
  *	radisys_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
- *	@isich: True if the device is an ICH and has IOCFG registers
  *
  *	Set MWDMA mode for device, in host controller PCI config space.
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

