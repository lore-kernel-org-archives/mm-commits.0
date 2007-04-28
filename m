From: akpm@linux-foundation.org
Subject: + pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch added to -mm tree
Date: Fri, 27 Apr 2007 18:49:48 -0700
Message-ID: <200704280149.l3S1nmiJ012821@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030872AbXD1BuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 21:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Fabrice.Aeschbacher@siemens.com, alan@redhat.com, bzolnier@gmail.com, fabrice.aeschbacher@siemens.com, stuge-linux-pcmcia@cdy.org


The patch titled
     pata_pcmcia: recognize 2GB CompactFlash from Transcend
has been added to the -mm tree.  Its filename is
     pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_pcmcia: recognize 2GB CompactFlash from Transcend
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>

Allow the pata_pcmcia driver to automatically detect 2GB CompactFlash cards
from Transcend.

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>
Cc: "Peter Stuge" <stuge-linux-pcmcia@cdy.org>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pcmcia.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/pata_pcmcia.c~pata_pcmcia-recognize-2gb-compactflash-from-transcend drivers/ata/pata_pcmcia.c
--- a/drivers/ata/pata_pcmcia.c~pata_pcmcia-recognize-2gb-compactflash-from-transcend
+++ a/drivers/ata/pata_pcmcia.c
@@ -396,6 +396,7 @@ static struct pcmcia_device_id pcmcia_de
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
_

Patches currently in -mm which might be from Fabrice.Aeschbacher@siemens.com are

pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch
ide-cs-recognize-2gb-compactflash-from-transcend.patch
