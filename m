From: akpm@linux-foundation.org
Subject: - irqh-fix-kernel-doc.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:59 -0700
Message-ID: <200707312357.l6VNvxqS029443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbXHAALj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:11:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     irq.h fix kernel-doc
has been removed from the -mm tree.  Its filename was
     irqh-fix-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: irq.h fix kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc entry in <linux/irq.h> for:

Warning(linux-2.6.22-git12//include/linux/irq.h:177): No description found for parameter 'last_unhandled'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    1 +
 1 file changed, 1 insertion(+)

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
fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
