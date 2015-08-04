From: akpm@linux-foundation.org
Subject: [merged]
 genirq-fix-warning-while-make-xmldocs-caused-by-chipc.patch removed from
 -mm tree
Date: Tue, 04 Aug 2015 16:33:48 -0700
Message-ID: <55c14bdc.iGXQnV9/VcqiR+DA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbbHDXdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 19:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/irq/chip.c: fix warning while make xmldocs caused by chip.c
has been removed from the -mm tree.  Its filename was
     genirq-fix-warning-while-make-xmldocs-caused-by-chipc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: kernel/irq/chip.c: fix warning while make xmldocs caused by chip.c

This patch fix following warning while make xmldocs.

Warning(.//kernel/irq/chip.c:1009): No description found for parameter 'vcpu_info'
Warning(.//kernel/irq/chip.c:1009): Excess function parameter 'dest' description in 'irq_chip_set_vcpu_affinity_parent'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/chip.c~genirq-fix-warning-while-make-xmldocs-caused-by-chipc kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-fix-warning-while-make-xmldocs-caused-by-chipc
+++ a/kernel/irq/chip.c
@@ -1003,7 +1003,7 @@ int irq_chip_retrigger_hierarchy(struct
 /**
  * irq_chip_set_vcpu_affinity_parent - Set vcpu affinity on the parent interrupt
  * @data:	Pointer to interrupt specific data
- * @dest:	The vcpu affinity information
+ * @vcpu_info:	The vcpu affinity information
  */
 int irq_chip_set_vcpu_affinity_parent(struct irq_data *data, void *vcpu_info)
 {
_

Patches currently in -mm which might be from standby24x7@gmail.com are

origin.patch
linux-next.patch
namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch

