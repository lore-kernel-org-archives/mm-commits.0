From: akpm@linux-foundation.org
Subject: + drivers-block-rdc-lower-printk-severity.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:39:07 -0700
Message-ID: <200707052139.l65Ld7Jp021242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760259AbXGEVjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org


The patch titled
     drivers/block/rd.c: lower printk severity
has been added to the -mm tree.  Its filename is
     drivers-block-rdc-lower-printk-severity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/block/rd.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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

fix-i-oat-for-kexec.patch
arch-x86_64-kernel-aperturec-lower-printk-severity.patch
arch-x86_64-kernel-e820c-lower-printk-severity.patch
net-ipv4-netfilter-ip_tablesc-lower-printk-severity.patch
drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity.patch
drivers-char-ipmi-ipmi_si_intfc-lower-printk-severity.patch
mm-page_allocc-lower-printk-severity.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch
arch-x86_64-kernel-processc-lower-printk-severity.patch
drivers-block-rdc-lower-printk-severity.patch
