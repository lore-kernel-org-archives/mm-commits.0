From: akpm@osdl.org
Subject: - pktcdvd-make-procfs-interface-optional.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:17 -0800
Message-ID: <200612082000.kB8K0HtF001723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56569 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426199AbWLHUA0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balagi@justmail.de, petero2@telia.com, mm-commits@vger.kernel.org


The patch titled
     pktcdvd: make procfs interface optional
has been removed from the -mm tree.  Its filename was
     pktcdvd-make-procfs-interface-optional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pktcdvd: make procfs interface optional
From: Thomas Maier <balagi@justmail.de>

pktcdvd: Update Kconfig help text.

Signed-off-by: Thomas Maier <balagi@justmail.de>
Signed-off-by: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/Kconfig |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/block/Kconfig~pktcdvd-make-procfs-interface-optional drivers/block/Kconfig
--- a/drivers/block/Kconfig~pktcdvd-make-procfs-interface-optional
+++ a/drivers/block/Kconfig
@@ -431,14 +431,18 @@ config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
 	help
-	  If you have a CDROM drive that supports packet writing, say Y to
-	  include preliminary support. It should work with any MMC/Mt Fuji
-	  compliant ATAPI or SCSI drive, which is just about any newer CD
-	  writer.
+	  If you have a CDROM/DVD drive that supports packet writing, say
+	  Y to include support. It should work with any MMC/Mt Fuji
+	  compliant ATAPI or SCSI drive, which is just about any newer
+	  DVD/CD writer.
 
-	  Currently only writing to CD-RW, DVD-RW and DVD+RW discs is possible.
+	  Currently only writing to CD-RW, DVD-RW, DVD+RW and DVDRAM discs
+	  is possible.
 	  DVD-RW disks must be in restricted overwrite mode.
 
+	  See the file <file:Documentation/cdrom/packet-writing.txt>
+	  for further information on the use of this driver.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called pktcdvd.
 
_

Patches currently in -mm which might be from balagi@justmail.de are

origin.patch
pktcdvd-make-procfs-interface-optional.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
pktcdvd-add-sysfs-and-debugfs-interface.patch

