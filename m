From: akpm@linux-foundation.org
Subject: - drivers-block-rdc-lower-printk-severity.patch removed from -mm tree
Date: Mon, 16 Jul 2007 12:24:46 -0700
Message-ID: <200707161924.l6GJOkJj028542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761167AbXGPTZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 15:25:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, mm-commits@vger.kernel.org


The patch titled
     drivers/block/rd.c: lower printk severity
has been removed from the -mm tree.  Its filename was
     drivers-block-rdc-lower-printk-severity.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: drivers/block/rd.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/rd.c~drivers-block-rdc-lower-printk-severity drivers/block/rd.c
--- a/drivers/block/rd.c~drivers-block-rdc-lower-printk-severity
+++ a/drivers/block/rd.c
@@ -463,9 +463,9 @@ static int __init rd_init(void)
 	}
 
 	/* rd_size is given in kB */
-	printk("RAMDISK driver initialized: "
-		"%d RAM disks of %dK size %d blocksize\n",
-		CONFIG_BLK_DEV_RAM_COUNT, rd_size, rd_blocksize);
+	printk(KERN_INFO "RAMDISK driver initialized: "
+	       "%d RAM disks of %dK size %d blocksize\n",
+	       CONFIG_BLK_DEV_RAM_COUNT, rd_size, rd_blocksize);
 
 	return 0;
 out:
_

Patches currently in -mm which might be from da-x@monatomic.org are

origin.patch
drivers-block-rdc-lower-printk-severity.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch
arch-x86_64-kernel-processc-lower-printk-severity.patch
arch-x86_64-kernel-aperturec-lower-printk-severity.patch
arch-x86_64-kernel-e820c-lower-printk-severity.patch
