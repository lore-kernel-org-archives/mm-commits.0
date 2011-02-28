From: akpm@linux-foundation.org
Subject: [merged] drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:10:37 -0800
Message-ID: <201102282110.p1SLAbc0029318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187Ab1B1VLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matti.j.aaltonen@nokia.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/nfc/Kconfig: use full form of the NFC acronym
has been removed from the -mm tree.  Its filename was
     drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

