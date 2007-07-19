From: akpm@linux-foundation.org
Subject: + irqh-fix-kernel-doc.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:42:48 -0700
Message-ID: <200707192142.l6JLgmRB024518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454AbXGSVnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     irq.h fix kernel-doc
has been added to the -mm tree.  Its filename is
     irqh-fix-kernel-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: irq.h fix kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc entry in <linux/irq.h> for:

Warning(linux-2.6.22-git12//include/linux/irq.h:177): No description found for parameter 'last_unhandled'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/irq.h~irqh-fix-kernel-doc include/linux/irq.h
--- a/include/linux/irq.h~irqh-fix-kernel-doc
+++ a/include/linux/irq.h
@@ -140,6 +140,7 @@ struct irq_chip {
  * @wake_depth:		enable depth, for multiple set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
+ * @last_unhandled:	aging timer for unhandled count
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
  * @cpu:		cpu index useful for balancing
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
usbh-kernel-doc-additions.patch
docbook-bad-file-references.patch
profile-likely-unlikely-macros.patch
