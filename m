From: akpm@linux-foundation.org
Subject: [merged] linux-interrupth-fix-new-kernel-doc-warnings.patch
 removed from -mm tree
Date: Mon, 05 May 2014 12:28:56 -0700
Message-ID: <5367e678.dMPuoqJI4yL3ob5e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaEET26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 15:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rdunlap@infradead.org

Subject: [merged] linux-interrupth-fix-new-kernel-doc-warnings.patch removed from -mm tree
To: rdunlap@infradead.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 12:28:56 -0700


The patch titled
     Subject: linux/interrupt.h: fix new kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     linux-interrupth-fix-new-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: linux/interrupt.h: fix new kernel-doc warnings

Fix new kernel-doc warnings in <linux/interrupt.h>:

Warning(include/linux/interrupt.h:219): No description found for parameter 'cpumask'
Warning(include/linux/interrupt.h:219): Excess function parameter 'mask' description in 'irq_set_affinity'
Warning(include/linux/interrupt.h:236): No description found for parameter 'cpumask'
Warning(include/linux/interrupt.h:236): Excess function parameter 'mask' description in 'irq_force_affinity'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/interrupt.h~linux-interrupth-fix-new-kernel-doc-warnings include/linux/interrupt.h
--- a/include/linux/interrupt.h~linux-interrupth-fix-new-kernel-doc-warnings
+++ a/include/linux/interrupt.h
@@ -210,7 +210,7 @@ extern int __irq_set_affinity(unsigned i
 /**
  * irq_set_affinity - Set the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Fails if cpumask does not contain an online CPU
  */
@@ -223,7 +223,7 @@ irq_set_affinity(unsigned int irq, const
 /**
  * irq_force_affinity - Force the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Same as irq_set_affinity, but without checking the mask against
  * online cpus.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix.patch
fs-9p-kerneldoc-fixes.patch
fs-befs-kernel-doc-fixes.patch
documentation-submittingpatches-describe-the-fixes-tag.patch
sysrq-rcu-ify-__handle_sysrq.patch
sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

