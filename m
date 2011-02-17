From: akpm@linux-foundation.org
Subject: + drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym.patch added to -mm tree
Date: Thu, 17 Feb 2011 13:48:33 -0800
Message-ID: <201102172148.p1HLmXWi013688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506Ab1BQVtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 16:49:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matti.j.aaltonen@nokia.com, w.sang@pengutronix.de


The patch titled
     drivers/nfc/Kconfig: use full form of the NFC acronym
has been added to the -mm tree.  Its filename is
     drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym.patch

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
Subject: drivers/nfc/Kconfig: use full form of the NFC acronym
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>

Spell out the NFC acronym when it's shown for the first time.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nfc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/nfc/Kconfig~drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym drivers/nfc/Kconfig
--- a/drivers/nfc/Kconfig~drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym
+++ a/drivers/nfc/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig NFC_DEVICES
-	bool "NFC devices"
+	bool "Near Field Communication (NFC) devices"
 	default n
 	---help---
 	  You'll have to say Y if your computer contains an NFC device that
_

Patches currently in -mm which might be from matti.j.aaltonen@nokia.com are

drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym.patch

