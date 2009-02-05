From: akpm@linux-foundation.org
Subject: [merged] ftdi_sio-add-support-for-the-ndi-polaris-system.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:43 -0800
Message-ID: <200902051914.n15JEhbL012143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759903AbZBETPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:15:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephane.clerambault@free.fr, abbotti@mev.co.uk, greg@kroah.com, oneukum@suse.de, mm-commits@vger.kernel.org


The patch titled
     ftdi_sio: add support for the NDI Polaris system
has been removed from the -mm tree.  Its filename was
     ftdi_sio-add-support-for-the-ndi-polaris-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftdi_sio: add support for the NDI Polaris system
From: Stephane Clerambault <stephane.clerambault@free.fr>

Add support for the NDI Polaris system *http://www.ndigital.com/).

Cc: Greg KH <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    3 +++
 2 files changed, 4 insertions(+)

diff -puN drivers/usb/serial/ftdi_sio.c~ftdi_sio-add-support-for-the-ndi-polaris-system drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~ftdi_sio-add-support-for-the-ndi-polaris-system
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -662,6 +662,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ USB_DEVICE(ALTI2_VID, ALTI2_N3_PID) },
 	{ USB_DEVICE(FTDI_VID, DIEBOLD_BCS_SE923_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NDI_HUC_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -puN drivers/usb/serial/ftdi_sio.h~ftdi_sio-add-support-for-the-ndi-polaris-system drivers/usb/serial/ftdi_sio.h
--- a/drivers/usb/serial/ftdi_sio.h~ftdi_sio-add-support-for-the-ndi-polaris-system
+++ a/drivers/usb/serial/ftdi_sio.h
@@ -844,6 +844,9 @@
 #define TML_VID			0x1B91	/* Vendor ID */
 #define TML_USB_SERIAL_PID	0x0064	/* USB - Serial Converter */
 
+/* NDI Polaris System */
+#define FTDI_NDI_HUC_PID        0xDA70
+
 /* Propox devices */
 #define FTDI_PROPOX_JTAGCABLEII_PID	0xD738
 
_

Patches currently in -mm which might be from stephane.clerambault@free.fr are

linux-next.patch

