From: akpm@linux-foundation.org
Subject: + rt2870-new-usb-id-for-belkin-n-f5d8055.patch added to -mm tree
Date: Wed, 12 Aug 2009 15:02:10 -0700
Message-ID: <200908122202.n7CM2AsN024515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbZHLWCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 18:02:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dnax88@gmail.com


The patch titled
     rt2870: new USB ID for Belkin N+ F5D8055
has been added to the -mm tree.  Its filename is
     rt2870-new-usb-id-for-belkin-n-f5d8055.patch

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
Subject: rt2870: new USB ID for Belkin N+ F5D8055
From: Daniele Napolitano <dnax88@gmail.com>

New USB ID for Belkin N+ F5D8055 (USB 802.11n adapter).

Signed-off-by: Daniele Napolitano <dnax88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2870/rt2870.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/rt2870/rt2870.h~rt2870-new-usb-id-for-belkin-n-f5d8055 drivers/staging/rt2870/rt2870.h
--- a/drivers/staging/rt2870/rt2870.h~rt2870-new-usb-id-for-belkin-n-f5d8055
+++ a/drivers/staging/rt2870/rt2870.h
@@ -102,6 +102,7 @@
 	{USB_DEVICE(0x14B2,0x3C12)}, /* AL */           \
 	{USB_DEVICE(0x050D,0x8053)}, /* Belkin */		\
 	{USB_DEVICE(0x050D,0x815C)}, /* Belkin */		\
+	{USB_DEVICE(0x050D,0x825a)}, /* Belkin */		\
 	{USB_DEVICE(0x14B2,0x3C23)}, /* Airlink */		\
 	{USB_DEVICE(0x14B2,0x3C27)}, /* Airlink */		\
 	{USB_DEVICE(0x07AA,0x002F)}, /* Corega */		\
_

Patches currently in -mm which might be from dnax88@gmail.com are

rt2870-new-usb-id-for-belkin-n-f5d8055.patch

