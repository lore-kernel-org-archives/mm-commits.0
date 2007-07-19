From: akpm@linux-foundation.org
Subject: - arch-x86_64-kernel-processc-lower-printk-severity.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:27 -0700
Message-ID: <200707192010.l6JKARB7020674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129AbXGSUPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, mm-commits@vger.kernel.org


The patch titled
     arch/x86_64/kernel/process.c: lower printk severity
has been removed from the -mm tree.  Its filename was
     arch-x86_64-kernel-processc-lower-printk-severity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -279,7 +279,7 @@ void __cpuinit select_idle_routine(const
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

origin.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch
