From: akpm@linux-foundation.org
Subject: + kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:51:07 -0400
Message-ID: <201003230651.o2N6pwHG019199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab0CWGwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@ahash.de, greg@kroah.com


The patch titled
     kaweth: new USB ID 07c9:b010 Allied Telesyn AT-USB10
has been added to the -mm tree.  Its filename is
     kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10.patch

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
Subject: kaweth: new USB ID 07c9:b010 Allied Telesyn AT-USB10
From: Andreas Hartmann <andi@ahash.de>

New USB ID 07c9:b010 Allied Telesyn AT-USB10.

Signed-off-by: Andreas Hartmann <andi@ahash.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/kaweth.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/usb/kaweth.c~kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10 drivers/net/usb/kaweth.c
--- a/drivers/net/usb/kaweth.c~kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10
+++ a/drivers/net/usb/kaweth.c
@@ -145,6 +145,7 @@ static struct usb_device_id usb_klsi_tab
 	{ USB_DEVICE(0x0707, 0x0100) }, /* SMC 2202USB */
 	{ USB_DEVICE(0x07aa, 0x0001) }, /* Correga K.K. */
 	{ USB_DEVICE(0x07b8, 0x4000) }, /* D-Link DU-E10 */
+	{ USB_DEVICE(0x07c9, 0xb010) }, /* Allied Telesyn AT-USB10 */
 	{ USB_DEVICE(0x0846, 0x1001) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x0846, 0x1002) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x085a, 0x0008) }, /* PortGear Ethernet Adapter */
_

Patches currently in -mm which might be from andi@ahash.de are

kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10.patch

