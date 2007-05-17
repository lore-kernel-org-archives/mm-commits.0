From: akpm@linux-foundation.org
Subject: + usb-remove-duplicate-ids-from-option-card-driver.patch added to -mm tree
Date: Thu, 17 May 2007 11:54:14 -0700
Message-ID: <200705171854.l4HIsEJ4030435@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbXEQS5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben.collins@ubuntu.com, bcollins@ubuntu.com, greg@kroah.com, smurf@smurf.noris.de


The patch titled
     usb: remove duplicate IDs from option card driver
has been added to the -mm tree.  Its filename is
     usb-remove-duplicate-ids-from-option-card-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: remove duplicate IDs from option card driver
From: Ben Collins <ben.collins@ubuntu.com>

Cc: Matthias Urlichs <smurf@smurf.noris.de>
Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/usb/serial/option.c~usb-remove-duplicate-ids-from-option-card-driver drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-remove-duplicate-ids-from-option-card-driver
+++ a/drivers/usb/serial/option.c
@@ -165,7 +165,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1410) }, /* Novatel U740 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1420) }, /* Novatel EU870 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1430) }, /* Novatel Merlin XU870 HSDPA/3G */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1430) }, /* Novatel XU870 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2100) }, /* Novatel EV620 CDMA/EV-DO */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2110) }, /* Novatel Merlin ES620 / Merlin ES720 / Ovation U720 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2130) }, /* Novatel Merlin ES620 SM Bus */
_

Patches currently in -mm which might be from ben.collins@ubuntu.com are

usb-remove-duplicate-ids-from-option-card-driver.patch
avoid-zero-size-allocation-in-cache_k8_northbridges.patch
