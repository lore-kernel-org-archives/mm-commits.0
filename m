From: akpm@linux-foundation.org
Subject: - drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:36 -0700
Message-ID: <200707162059.l6GKxa99002439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757725AbXGPVFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ipmi/ipmi_poweroff.c: lower printk severity
has been removed from the -mm tree.  Its filename was
     drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/ipmi/ipmi_poweroff.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_poweroff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch
arch-x86_64-kernel-processc-lower-printk-severity.patch
arch-x86_64-kernel-aperturec-lower-printk-severity.patch
arch-x86_64-kernel-e820c-lower-printk-severity.patch
