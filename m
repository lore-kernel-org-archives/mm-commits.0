From: akpm@linux-foundation.org
Subject: - drivers-ata-pata_c-the-rest-remove-redundant-comments.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:10 -0800
Message-ID: <200811262046.mAQKkADs010600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbYKZU5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:57:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/pata_*c: the rest, remove redundant comments
has been removed from the -mm tree.  Its filename was
     drivers-ata-pata_c-the-rest-remove-redundant-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/ata/pata_*c: the rest, remove redundant comments
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

Remove some redundant argument comments in pata_*.c

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_bf54x.c       |    1 -
 drivers/ata/pata_scc.c         |    1 -
 drivers/ata/pata_serverworks.c |    1 -
 drivers/ata/sata_mv.c          |    1 -
 4 files changed, 4 deletions(-)

diff -puN drivers/ata/pata_bf54x.c~drivers-ata-pata_c-the-rest-remove-redundant-comments drivers/ata/pata_bf54x.c
--- a/drivers/ata/pata_bf54x.c~drivers-ata-pata_c-the-rest-remove-redundant-comments
+++ a/drivers/ata/pata_bf54x.c
@@ -356,7 +356,6 @@ static void bfin_set_piomode(struct ata_
  *	bfin_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: um
- *	@udma: udma mode, 0 - 6
  *
  *	Set UDMA mode for device.
  *
diff -puN drivers/ata/pata_scc.c~drivers-ata-pata_c-the-rest-remove-redundant-comments drivers/ata/pata_scc.c
--- a/drivers/ata/pata_scc.c~drivers-ata-pata_c-the-rest-remove-redundant-comments
+++ a/drivers/ata/pata_scc.c
@@ -210,7 +210,6 @@ static void scc_set_piomode (struct ata_
  *	scc_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: um
- *	@udma: udma mode, 0 - 6
  *
  *	Set UDMA mode for device.
  *
diff -puN drivers/ata/pata_serverworks.c~drivers-ata-pata_c-the-rest-remove-redundant-comments drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~drivers-ata-pata_c-the-rest-remove-redundant-comments
+++ a/drivers/ata/pata_serverworks.c
@@ -138,7 +138,6 @@ static struct sv_cable_table cable_detec
 /**
  *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
diff -puN drivers/ata/sata_mv.c~drivers-ata-pata_c-the-rest-remove-redundant-comments drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~drivers-ata-pata_c-the-rest-remove-redundant-comments
+++ a/drivers/ata/sata_mv.c
@@ -1836,7 +1836,6 @@ static void mv_unexpected_intr(struct at
 /**
  *      mv_err_intr - Handle error interrupts on the port
  *      @ap: ATA channel to manipulate
- *      @qc: affected command (non-NCQ), or NULL
  *
  *      Most cases require a full reset of the chip's state machine,
  *      which also performs a COMRESET.
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

linux-next.patch
samples-mark-static__init__exit-for-initexit-functions.patch
fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch

