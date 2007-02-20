From: akpm@linux-foundation.org
Subject: - remove-useless-find_first_bit-macro-from-cardbusc.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:10:50 -0800
Message-ID: <200702202010.l1KKAo0c018305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46978 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030412AbXBTUK6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:10:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     Remove useless FIND_FIRST_BIT() macro from cardbus.c
has been removed from the -mm tree.  Its filename was
     remove-useless-find_first_bit-macro-from-cardbusc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove useless FIND_FIRST_BIT() macro from cardbus.c
From: "Robert P. J. Day" <rpjday@mindspring.com>

Delete the definition of the unused FIND_FIRST_BIT() macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pcmcia/cardbus.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/pcmcia/cardbus.c~remove-useless-find_first_bit-macro-from-cardbusc drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c~remove-useless-find_first_bit-macro-from-cardbusc
+++ a/drivers/pcmcia/cardbus.c
@@ -40,8 +40,6 @@
 
 /*====================================================================*/
 
-#define FIND_FIRST_BIT(n)	((n) - ((n) & ((n)-1)))
-
 /* Offsets in the Expansion ROM Image Header */
 #define ROM_SIGNATURE		0x0000	/* 2 bytes */
 #define ROM_DATA_PTR		0x0018	/* 2 bytes */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
git-mips.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
