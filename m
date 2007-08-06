From: akpm@linux-foundation.org
Subject: - fix-runtogether-printks-in-cmd64x-ide-driver.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:22 -0700
Message-ID: <200708060753.l767rMfn016328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759173AbXHFHxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mroos@linux.ee, mm-commits@vger.kernel.org


The patch titled
     fix runtogether printk's in cmd64x IDE driver
has been removed from the -mm tree.  Its filename was
     fix-runtogether-printks-in-cmd64x-ide-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix runtogether printk's in cmd64x IDE driver
From: Meelis Roos <mroos@linux.ee>

Fix a couple of runtogether printks in cmd64x.c IDE driver by adding
proper newlines.

Signed-off-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/cmd64x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ide/pci/cmd64x.c~fix-runtogether-printks-in-cmd64x-ide-driver drivers/ide/pci/cmd64x.c
--- a/drivers/ide/pci/cmd64x.c~fix-runtogether-printks-in-cmd64x-ide-driver
+++ a/drivers/ide/pci/cmd64x.c
@@ -460,11 +460,11 @@ static unsigned int __devinit init_chips
 		switch (rev) {
 		case 0x07:
 		case 0x05:
-			printk("%s: UltraDMA capable", name);
+			printk("%s: UltraDMA capable\n", name);
 			break;
 		case 0x03:
 		default:
-			printk("%s: MultiWord DMA force limited", name);
+			printk("%s: MultiWord DMA force limited\n", name);
 			break;
 		case 0x01:
 			printk("%s: MultiWord DMA limited, "
_

Patches currently in -mm which might be from mroos@linux.ee are

git-acpi.patch
