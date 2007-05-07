From: akpm@linux-foundation.org
Subject: - ide-cs-recognize-2gb-compactflash-from-transcend.patch removed from -mm tree
Date: Sun, 06 May 2007 23:47:05 -0700
Message-ID: <200705070647.l476l5RW020368@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbXEGGrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Fabrice.Aeschbacher@siemens.com, bzolnier@gmail.com, fabrice.aeschbacher@siemens.com, linux@dominikbrodowski.net, peter@stuge.se, mm-commits@vger.kernel.org


The patch titled
     ide-cs: recognize 2GB CompactFlash from Transcend
has been removed from the -mm tree.  Its filename was
     ide-cs-recognize-2gb-compactflash-from-transcend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide-cs: recognize 2GB CompactFlash from Transcend
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>

Without the following patch, the kernel does not automatically detect
2GB CompactFlash cards from Transcend.

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Peter Stuge <peter@stuge.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/legacy/ide-cs.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend drivers/ide/legacy/ide-cs.c
--- a/drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend
+++ a/drivers/ide/legacy/ide-cs.c
@@ -401,6 +401,7 @@ static struct pcmcia_device_id ide_ids[]
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
_

Patches currently in -mm which might be from Fabrice.Aeschbacher@siemens.com are

origin.patch
pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch
