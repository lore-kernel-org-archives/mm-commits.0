From: akpm@linux-foundation.org
Subject: + genirq-fix-warning-while-make-xmldocs-caused-by-chipc.patch
 added to -mm tree
Date: Wed, 29 Jul 2015 13:31:11 -0700
Message-ID: <55b9380f.rnY8jE6NKuRbOnG7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbG2UbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 16:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/irq/chip.c: fix warning while make xmldocs caused by chip.c
has been added to the -mm tree.  Its filename is
     genirq-fix-warning-while-make-xmldocs-caused-by-chipc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genirq-fix-warning-while-make-xmldocs-caused-by-chipc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genirq-fix-warning-while-make-xmldocs-caused-by-chipc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

genirq-fix-warning-while-make-xmldocs-caused-by-chipc.patch
linux-next.patch
namei-fix-warning-while-make-xmldocs-caused-by-nameic.patch

