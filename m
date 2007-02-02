From: akpm@linux-foundation.org
Subject: - via82cxxx-fix-typo-cx7000-should-be-corrected-to-cx700.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:37:59 -0800
Message-ID: <200702022137.l12LbxA0018552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946115AbXBBViC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:38:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, JosephChan@via.com.tw, mm-commits@vger.kernel.org


The patch titled
     via82cxxx: fix typo ("cx7000" should be corrected to "cx700")
has been removed from the -mm tree.  Its filename was
     via82cxxx-fix-typo-cx7000-should-be-corrected-to-cx700.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: via82cxxx: fix typo ("cx7000" should be corrected to "cx700")
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Noticed by <JosephChan@via.com.tw>

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/via82cxxx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ide/pci/via82cxxx.c~via82cxxx-fix-typo-cx7000-should-be-corrected-to-cx700 drivers/ide/pci/via82cxxx.c
--- a/drivers/ide/pci/via82cxxx.c~via82cxxx-fix-typo-cx7000-should-be-corrected-to-cx700
+++ a/drivers/ide/pci/via82cxxx.c
@@ -78,7 +78,7 @@ static struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
-	{ "cx7000",	PCI_DEVICE_ID_VIA_CX700,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
+	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
mm-ide-ide-acpi-support-warning-fix.patch
