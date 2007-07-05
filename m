From: akpm@linux-foundation.org
Subject: + drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:38:57 -0700
Message-ID: <200707052138.l65Lcvgk021159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760682AbXGEVjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org


The patch titled
     drivers/char/ipmi/ipmi_poweroff.c: lower printk severity
has been added to the -mm tree.  Its filename is
     drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/ipmi/ipmi_poweroff.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_poweroff.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_poweroff.c~drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -679,7 +679,7 @@ static int ipmi_poweroff_init (void)
 {
 	int rv;
 
-	printk ("Copyright (C) 2004 MontaVista Software -"
+	printk (KERN_INFO "Copyright (C) 2004 MontaVista Software -"
 		" IPMI Powerdown via sys_reboot.\n");
 
 	if (poweroff_powercycle)
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
