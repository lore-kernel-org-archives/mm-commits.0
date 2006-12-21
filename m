From: akpm@osdl.org
Subject: - bluetooth-add-support-for-another-kensington-dongle.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:37:11 -0800
Message-ID: <200612210037.kBL0bBkO011275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53616 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161126AbWLUAki (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:40:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galibert@pobox.com, greg@kroah.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: add support for another Kensington dongle
has been removed from the -mm tree.  Its filename was
     bluetooth-add-support-for-another-kensington-dongle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bluetooth: add support for another Kensington dongle
From: Olivier Galibert <galibert@pobox.com>

Add the stupid sco fixup quirk to yet another Broadcom/Kensington device.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/bluetooth/hci_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bluetooth/hci_usb.c~bluetooth-add-support-for-another-kensington-dongle drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-add-support-for-another-kensington-dongle
+++ a/drivers/bluetooth/hci_usb.c
@@ -126,6 +126,7 @@ static struct usb_device_id blacklist_id
 
 	/* Kensington Bluetooth USB adapter */
 	{ USB_DEVICE(0x047d, 0x105d), .driver_info = HCI_RESET },
+	{ USB_DEVICE(0x047d, 0x105e), .driver_info = HCI_WRONG_SCO_MTU },
 
 	/* ISSC Bluetooth Adapter v3.1 */
 	{ USB_DEVICE(0x1131, 0x1001), .driver_info = HCI_RESET },
_

Patches currently in -mm which might be from galibert@pobox.com are

pci-mmconfig-share-whats-shareable.patch
pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch
pci-mmconfig-only-map-whats-necessary.patch
pci-mmconfig-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
pci-mmconfig-reserve-resources-but-only-when-were-sure-about-them.patch

