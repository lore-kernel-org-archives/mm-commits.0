From: akpm@linux-foundation.org
Subject: [merged] spih-add-missing-kernel-doc-for-struct-spi_master.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:44 -0700
Message-ID: <200909231957.n8NJvi2l007531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741AbZIWT6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi.h: add missing kernel-doc for struct spi_master
has been removed from the -mm tree.  Its filename was
     spih-add-missing-kernel-doc-for-struct-spi_master.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi.h: add missing kernel-doc for struct spi_master
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc notation in spi.h for struct spi_master:

Warning(include/linux/spi/spi.h:289): No description found for parameter 'mode_bits'
Warning(include/linux/spi/spi.h:289): No description found for parameter 'flags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/spi/spi.h~spih-add-missing-kernel-doc-for-struct-spi_master include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spih-add-missing-kernel-doc-for-struct-spi_master
+++ a/include/linux/spi/spi.h
@@ -207,6 +207,8 @@ static inline void spi_unregister_driver
  *	each slave has a chipselect signal, but it's common that not
  *	every chipselect is connected to a slave.
  * @dma_alignment: SPI controller constraint on DMA buffers alignment.
+ * @mode_bits: flags understood by this controller driver
+ * @flags: other constraints relevant to this driver
  * @setup: updates the device mode and clocking records used by a
  *	device's SPI controller; protocol code may call this.  This
  *	must fail if an unrecognized or unsupported mode is requested.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
include-linux-credh-fix-build.patch
scsi-fix-func-names-in-kernel-doc.patch
scsi_transport_fc-fix-missing-kernel-doc.patch
wl12xx-fix-kconfig-link-errors.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

