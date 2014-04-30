From: akpm@linux-foundation.org
Subject: + linux-interrupth-fix-new-kernel-doc-warnings.patch added to -mm tree
Date: Wed, 30 Apr 2014 15:28:44 -0700
Message-ID: <5361791c.RT0VhuNadIt7OLXa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaD3W2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 18:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rdunlap@infradead.org

Subject: + linux-interrupth-fix-new-kernel-doc-warnings.patch added to -mm tree
To: rdunlap@infradead.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 15:28:44 -0700


The patch titled
     Subject: linux/interrupt.h: fix new kernel-doc warnings
has been added to the -mm tree.  Its filename is
     linux-interrupth-fix-new-kernel-doc-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-interrupth-fix-new-kernel-doc-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-interrupth-fix-new-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-interrupth-fix-new-kernel-doc-warnings.patch
fs-9p-kerneldoc-fixes.patch
fs-befs-kernel-doc-fixes.patch
documentation-submittingpatches-describe-the-fixes-tag.patch
sysrq-rcu-ify-__handle_sysrq.patch
sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

