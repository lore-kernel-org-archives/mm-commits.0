From: akpm@linux-foundation.org
Subject: + rt2870-add-usb-id-for-sitecom-wl-608.patch added to -mm tree
Date: Mon, 22 Jun 2009 11:20:53 -0700
Message-ID: <200906221820.n5MIKrXL029853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbZFVSV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 14:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jorrit@ncode.nl, greg@kroah.com


The patch titled
     rt2870: add USB ID for Sitecom WL-608
has been added to the -mm tree.  Its filename is
     rt2870-add-usb-id-for-sitecom-wl-608.patch

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
Subject: rt2870: add USB ID for Sitecom WL-608
From: Jorrit Schippers <jorrit@ncode.nl>

Add the USB id 0x0DF6,0x003F to the rt2870.h file such that the Sitecom
WL-608 device will be recognized by this driver.

Signed-off-by: Jorrit Schippers <jorrit@ncode.nl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2870/rt2870.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/rt2870/rt2870.h~rt2870-add-usb-id-for-sitecom-wl-608 drivers/staging/rt2870/rt2870.h
--- a/drivers/staging/rt2870/rt2870.h~rt2870-add-usb-id-for-sitecom-wl-608
+++ a/drivers/staging/rt2870/rt2870.h
@@ -89,6 +89,7 @@
 	{USB_DEVICE(0x0DF6,0x002C)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x002D)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x0039)}, /* Sitecom */		\
+	{USB_DEVICE(0x0DF6,0x003F)}, /* Sitecom WL-608 */	\
 	{USB_DEVICE(0x14B2,0x3C06)}, /* Conceptronic */		\
 	{USB_DEVICE(0x14B2,0x3C28)}, /* Conceptronic */		\
 	{USB_DEVICE(0x2019,0xED06)}, /* Planex Communications, Inc. */		\
_

Patches currently in -mm which might be from jorrit@ncode.nl are

rt2870-add-usb-id-for-sitecom-wl-608.patch

