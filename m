From: akpm@linux-foundation.org
Subject: - prism54-support-for-124a4025-another-version-of-iogear-gwu513-80211g.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:37 -0700
Message-ID: <200803172100.m2HL0bt5030871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbYCQVCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslupski@juljas.net, flamingice@sourmilk.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     prism54: support for 124a:4025 - another version of IOGear GWU513 802.11g
has been removed from the -mm tree.  Its filename was
     prism54-support-for-124a4025-another-version-of-iogear-gwu513-80211g.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: prism54: support for 124a:4025 - another version of IOGear GWU513 802.11g
From: Jan Slupski <jslupski@juljas.net>

Add support to p54usb driver for apparently another version of IOGear GWU513
802.11g USB network card that uses GW3887IK chipset and is recognized as
"124a:4025 AirVast" by lsusb.

Cc: John W. Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/p54usb.c~prism54-support-for-124a4025-another-version-of-iogear-gwu513-80211g drivers/net/wireless/p54usb.c
--- a/drivers/net/wireless/p54usb.c~prism54-support-for-124a4025-another-version-of-iogear-gwu513-80211g
+++ a/drivers/net/wireless/p54usb.c
@@ -63,6 +63,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
+	{USB_DEVICE(0x124a, 0x4025)},	/* IOGear GWU513 (GW3887IK chip) */
 	{USB_DEVICE(0x13b1, 0x000a)},	/* Linksys WUSB54G ver 2 */
 	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
_

Patches currently in -mm which might be from jslupski@juljas.net are

git-net.patch

