From: akpm@linux-foundation.org
Subject: [merged] optionc-support-qualcomm-icon-210.patch removed from -mm tree
Date: Fri, 07 Aug 2009 13:59:00 -0700
Message-ID: <200908072059.n77Kx1Qx010806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039AbZHGU7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 16:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     option.c: support QUALCOMM iCON 210
has been removed from the -mm tree.  Its filename was
     optionc-support-qualcomm-icon-210.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: option.c: support QUALCOMM iCON 210
=46rom: Hanno B=F6ck

Support the QUALCOMM HSDPA-Stick iCON 210.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/usb/serial/option.c~optionc-support-qualcomm-icon-210=
 drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~optionc-support-qualcomm-icon-210
+++ a/drivers/usb/serial/option.c
@@ -288,6 +288,9 @@ static int  option_resume(struct usb_ser
=20
 #define QUALCOMM_VENDOR_ID			0x05C6
=20
+#define QUALCOMM_ICON_VENDOR_ID			0x1E0E
+#define QUALCOMM_ICON_PRODUCT_210		0x9000
+
 #define MAXON_VENDOR_ID				0x16d8
=20
 #define TELIT_VENDOR_ID				0x1bc7
@@ -495,6 +498,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
+	{ USB_DEVICE(QUALCOMM_ICON_VENDOR_ID, QUALCOMM_ICON_PRODUCT_210)}, /*=
 Qualcomm iCON 210 */
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA *=
/
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xf=
f, 0xff, 0xff) }, /* ZTE WCDMA products */
_

Patches currently in -mm which might be from greg@kroah.com are

linux-next.patch
vt6655-s-void-void.patch
staging-rt2860-remove-dependency-on-wireless_ext-version.patch
staging-udlfb-fix-printk-format-warning.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
optionc-support-qualcomm-icon-210.patch
usb-gadget-read-buffer-overflow.patch
ark3116-add-irda-support-for-gembird-uir-22.patch
n_tty-honor-opost-flag-for-echoes.patch
n_tty-move-echoctl-check-and-clean-up-logic.patch
gigaset-really-fix-chars_in_buffer.patch
usb-storage-include-prolific-technology-usb-drive-in-unusual_devs-list.=
patch
make-sure-nobodys-leaking-resources.patch
workaround-for-a-pci-restoring-bug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
