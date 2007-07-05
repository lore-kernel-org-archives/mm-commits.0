From: akpm@linux-foundation.org
Subject: + net-ipv4-netfilter-ip_tablesc-lower-printk-severity.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:38:55 -0700
Message-ID: <200707052138.l65Lctem021156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760479AbXGEVjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org


The patch titled
     net/ipv4/netfilter/ip_tables.c: lower printk severity
has been added to the -mm tree.  Its filename is
     net-ipv4-netfilter-ip_tablesc-lower-printk-severity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net/ipv4/netfilter/ip_tables.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/ip_tables.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/netfilter/ip_tables.c~net-ipv4-netfilter-ip_tablesc-lower-printk-severity net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c~net-ipv4-netfilter-ip_tablesc-lower-printk-severity
+++ a/net/ipv4/netfilter/ip_tables.c
@@ -2230,7 +2230,7 @@ static int __init ip_tables_init(void)
 	if (ret < 0)
 		goto err5;
 
-	printk("ip_tables: (C) 2000-2006 Netfilter Core Team\n");
+	printk(KERN_INFO "ip_tables: (C) 2000-2006 Netfilter Core Team\n");
 	return 0;
 
 err5:
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
