From: akpm@linux-foundation.org
Subject: + arch-x86_64-kernel-processc-lower-printk-severity.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:39:05 -0700
Message-ID: <200707052139.l65Ld5OM021239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759996AbXGEVjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org


The patch titled
     arch/x86_64/kernel/process.c: lower printk severity
has been added to the -mm tree.  Its filename is
     arch-x86_64-kernel-processc-lower-printk-severity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/x86_64/kernel/process.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/process.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/process.c~arch-x86_64-kernel-processc-lower-printk-severity arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~arch-x86_64-kernel-processc-lower-printk-severity
+++ a/arch/x86_64/kernel/process.c
@@ -283,7 +283,7 @@ void __cpuinit select_idle_routine(const
 		 */
 		if (!pm_idle) {
 			if (!printed) {
-				printk("using mwait in idle threads.\n");
+				printk(KERN_INFO "using mwait in idle threads.\n");
 				printed = 1;
 			}
 			pm_idle = mwait_idle;
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
