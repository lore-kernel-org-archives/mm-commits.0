From: akpm@linux-foundation.org
Subject: + spih-add-missing-kernel-doc-for-struct-spi_master.patch added to -mm tree
Date: Fri, 17 Jul 2009 17:15:43 -0700
Message-ID: <200907180015.n6I0FhnM012977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758082AbZGRAQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 20:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dbrownell@users.sourceforge.net


The patch titled
     spi.h: add missing kernel-doc for struct spi_master
has been added to the -mm tree.  Its filename is
     spih-add-missing-kernel-doc-for-struct-spi_master.patch

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

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
maintainers-coalesce-name-and-email-address-lines.patch
lis3-add-power-management-functions-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
reiser4-export-remove_from_page_cache-fix.patch

