From: akpm@linux-foundation.org
Subject: + rtl8187-support-of-belkin-f5d7050rev5000de.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:01:44 -0700
Message-ID: <200810161901.m9GJ1ipE003786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbYJPTCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florent.fourcot@enst-bretagne.fr, Larry.Finger@lwfinger.net, greg@kroah.com


The patch titled
     rtl8187: support of Belkin "F5D7050rev5000de"
has been added to the -mm tree.  Its filename is
     rtl8187-support-of-belkin-f5d7050rev5000de.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtl8187: support of Belkin "F5D7050rev5000de"
From: Florent Fourcot <florent.fourcot@enst-bretagne.fr>

This Belkin product (id 050d:705e) use Realtek's RTL8187B and works fine
with the new 2.6.27 driver.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rtl8187_dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/wireless/rtl8187_dev.c~rtl8187-support-of-belkin-f5d7050rev5000de drivers/net/wireless/rtl8187_dev.c
--- a/drivers/net/wireless/rtl8187_dev.c~rtl8187-support-of-belkin-f5d7050rev5000de
+++ a/drivers/net/wireless/rtl8187_dev.c
@@ -33,6 +33,8 @@ MODULE_LICENSE("GPL");
 static struct usb_device_id rtl8187_table[] __devinitdata = {
 	/* Asus */
 	{USB_DEVICE(0x0b05, 0x171d), .driver_info = DEVICE_RTL8187},
+	/* Belkin */
+	{USB_DEVICE(0x050d, 0x705e), .driver_info = DEVICE_RTL8187B},
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
_

Patches currently in -mm which might be from florent.fourcot@enst-bretagne.fr are

rtl8187-support-of-belkin-f5d7050rev5000de.patch

