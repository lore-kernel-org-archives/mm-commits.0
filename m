From: akpm@linux-foundation.org
Subject: + usb-yet-another-dell-wireless-cdma-evdo-modem.patch added to -mm tree
Date: Wed, 23 Jan 2008 13:53:14 -0800
Message-ID: <200801232153.m0NLr6iA028163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbYAWVxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 16:53:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy@smile.org.ua, greg@kroah.com, smurf@smurf.noris.de


The patch titled
     usb: yet another Dell wireless CDMA/EVDO modem
has been added to the -mm tree.  Its filename is
     usb-yet-another-dell-wireless-cdma-evdo-modem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -180,6 +180,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8117) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO ExpressCard == Novatel Merlin XV620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8118) },	/* Dell Wireless 5510 Mobile Broadband HSDPA ExpressCard == Novatel Merlin XU870 HSDPA/3G */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8128) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite E720 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, 0x8129) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite ET620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8137) },	/* Dell Wireless HSDPA 5520 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
_

Patches currently in -mm which might be from andy@smile.org.ua are

git-alsa.patch
bluetooth-blacklist-another-broadcom-bcm2035-device.patch
usb-yet-another-dell-wireless-cdma-evdo-modem.patch
