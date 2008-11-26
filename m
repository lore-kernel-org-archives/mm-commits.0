From: akpm@linux-foundation.org
Subject: - drivers-ata-pata_radisysc-cleanup-kernel-doc.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:45:58 -0800
Message-ID: <200811262045.mAQKjw2F010493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbYKZUq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:46:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/pata_radisys.c: cleanup kernel-doc
has been removed from the -mm tree.  Its filename was
     drivers-ata-pata_radisysc-cleanup-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
samples-mark-static__init__exit-for-initexit-functions.patch
fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

