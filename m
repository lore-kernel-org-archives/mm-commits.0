From: akpm@linux-foundation.org
Subject: + fix-runtogether-printks-in-cmd64x-ide-driver.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:40:47 -0700
Message-ID: <200707302340.l6UNelFl004457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37108 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759355AbXG3XlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroos@linux.ee


The patch titled
     fix runtogether printk's in cmd64x IDE driver
has been added to the -mm tree.  Its filename is
     fix-runtogether-printks-in-cmd64x-ide-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

alpha-fix-mkbb-compilation-warnings.patch
alpha-fix-objstripc-compilation-warnings.patch
alpha-fix-boot-mainc-warning.patch
lib-move-kasprintf-to-a-separate-file.patch
add-a-missing-lib_y-to-arch-alpha-boot-makefile.patch
acpi-cure-run-together-printk-lines.patch
fix-runtogether-printks-in-cmd64x-ide-driver.patch
fix-integer-overflow-warning-in-i2o_block.patch
