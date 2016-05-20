From: akpm@linux-foundation.org
Subject: [merged] scripts-spellingtxt-add-fimware-misspelling.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:02:30 -0700
Message-ID: <573f7b66.GGvPT+Tt9qKJ3Fak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "fimware" misspelling
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-fimware-misspelling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: scripts/spelling.txt: add "fimware" misspelling

A few instances of "fimware" instead of "firmware" were found. Fix these
and add it to the spelling.txt file.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/usb/dvb-usb/dib0700_core.c      |    2 +-
 drivers/scsi/bfa/bfi.h                        |    2 +-
 drivers/staging/comedi/drivers/daqboard2000.c |    2 +-
 scripts/spelling.txt                          |    1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/media/usb/dvb-usb/dib0700_core.c~scripts-spellingtxt-add-fimware-misspelling drivers/media/usb/dvb-usb/dib0700_core.c
--- a/drivers/media/usb/dvb-usb/dib0700_core.c~scripts-spellingtxt-add-fimware-misspelling
+++ a/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -517,7 +517,7 @@ int dib0700_download_firmware(struct usb
 	if (nb_packet_buffer_size < 1)
 		nb_packet_buffer_size = 1;
 
-	/* get the fimware version */
+	/* get the firmware version */
 	usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				  REQUEST_GET_VERSION,
 				  USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
diff -puN drivers/scsi/bfa/bfi.h~scripts-spellingtxt-add-fimware-misspelling drivers/scsi/bfa/bfi.h
--- a/drivers/scsi/bfa/bfi.h~scripts-spellingtxt-add-fimware-misspelling
+++ a/drivers/scsi/bfa/bfi.h
@@ -356,7 +356,7 @@ struct bfi_ioc_image_hdr_s {
 	u8	port0_mode;	/* device mode for port 0	*/
 	u8	port1_mode;	/* device mode for port 1	*/
 	u32	exec;		/* exec vector			*/
-	u32	bootenv;	/* fimware boot env		*/
+	u32	bootenv;	/* firmware boot env		*/
 	u32	rsvd_b[2];
 	struct bfi_ioc_fwver_s	fwver;
 	u32	md5sum[BFI_IOC_MD5SUM_SZ];
diff -puN drivers/staging/comedi/drivers/daqboard2000.c~scripts-spellingtxt-add-fimware-misspelling drivers/staging/comedi/drivers/daqboard2000.c
--- a/drivers/staging/comedi/drivers/daqboard2000.c~scripts-spellingtxt-add-fimware-misspelling
+++ a/drivers/staging/comedi/drivers/daqboard2000.c
@@ -26,7 +26,7 @@
  * Much of the functionality of this driver was determined from reading
  * the source code for the Windows driver.
  *
- * The FPGA on the board requires fimware, which is available from
+ * The FPGA on the board requires firmware, which is available from
  * http://www.comedi.org in the comedi_nonfree_firmware tarball.
  *
  * Configuration options: not applicable, uses PCI auto config
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-fimware-misspelling scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-fimware-misspelling
+++ a/scripts/spelling.txt
@@ -428,6 +428,7 @@ feautures||features
 fetaure||feature
 fetaures||features
 fileystem||filesystem
+fimware||firmware
 finanize||finalize
 findn||find
 finilizes||finalizes
_

Patches currently in -mm which might be from keescook@chromium.org are


