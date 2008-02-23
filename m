From: akpm@linux-foundation.org
Subject: - usb-yet-another-dell-wireless-cdma-evdo-modem.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:04 -0800
Message-ID: <200802232023.m1NKN4TW013485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761987AbYBWU3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy@smile.org.ua, greg@kroah.com, smurf@smurf.noris.de, mm-commits@vger.kernel.org


The patch titled
     usb: yet another Dell wireless CDMA/EVDO modem
has been removed from the -mm tree.  Its filename was
     usb-yet-another-dell-wireless-cdma-evdo-modem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: yet another Dell wireless CDMA/EVDO modem
From: Andy Shevchenko <andy@smile.org.ua>

Add native support of the Dell wireless CDMA/EVDO modem.

# modprobe usbserial vendor=0x413c product=0x8129

Following seesion lines describe modem itself
at
OK
ati3
Manufacturer: NOVATEL WIRELESS INCORPORATED
Model: EXPEDITE ET620
Revision: M6500C-BBIRD_TLS_MINI_DELL-Q40306.166 [Aug 25 2006 14:00:00]
ESN: 0x5B39071D
+GCAP: +CIS707-A, CIS-856, +MS, +ES, +DS, +FCLASS

OK

Signed-off-by: Andy Shevchenko <andy@smile.org.ua>
Cc: Greg KH <greg@kroah.com>
Cc: Matthias Urlichs <smurf@smurf.noris.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/serial/option.c~usb-yet-another-dell-wireless-cdma-evdo-modem drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-yet-another-dell-wireless-cdma-evdo-modem
+++ a/drivers/usb/serial/option.c
@@ -181,6 +181,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8118) },	/* Dell Wireless 5510 Mobile Broadband HSDPA ExpressCard == Novatel Merlin XU870 HSDPA/3G */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8128) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite E720 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8136) },	/* Dell Wireless HSDPA 5520 == Novatel Expedite EU860D */
+	{ USB_DEVICE(DELL_VENDOR_ID, 0x8129) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite ET620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8137) },	/* Dell Wireless HSDPA 5520 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
_

Patches currently in -mm which might be from andy@smile.org.ua are

origin.patch
