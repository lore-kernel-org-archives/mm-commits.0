From: akpm@linux-foundation.org
Subject: [merged] rt2870-add-id-for-sitecom-wl-315.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:58 -0700
Message-ID: <200904071909.n37J9wRx012612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524AbZDGT4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dnax88@gmail.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     rt2870: add ID for Sitecom WL-315
has been removed from the -mm tree.  Its filename was
     rt2870-add-id-for-sitecom-wl-315.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rt2870: add ID for Sitecom WL-315
From: Daniele Napolitano <dnax88@gmail.com>

Signed-off-by: Daniele Napolitano <dnax88@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2870/rt2870.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/rt2870/rt2870.h~rt2870-add-id-for-sitecom-wl-315 drivers/staging/rt2870/rt2870.h
--- a/drivers/staging/rt2870/rt2870.h~rt2870-add-id-for-sitecom-wl-315
+++ a/drivers/staging/rt2870/rt2870.h
@@ -96,6 +96,7 @@
 	{USB_DEVICE(0x0DF6,0x002B)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x002C)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x002D)}, /* Sitecom */		\
+	{USB_DEVICE(0x0DF6,0x0039)}, /* Sitecom */		\
 	{USB_DEVICE(0x14B2,0x3C06)}, /* Conceptronic */		\
 	{USB_DEVICE(0x14B2,0x3C28)}, /* Conceptronic */		\
 	{USB_DEVICE(0x2019,0xED06)}, /* Planex Communications, Inc. */		\
_

Patches currently in -mm which might be from dnax88@gmail.com are

linux-next.patch

