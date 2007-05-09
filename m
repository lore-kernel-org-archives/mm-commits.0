From: akpm@linux-foundation.org
Subject: - fix-linuxdoc-comment.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:35 -0700
Message-ID: <200705092149.l49LnZeX002707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758859AbXEIVtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix Linuxdoc comment
has been removed from the -mm tree.  Its filename was
     fix-linuxdoc-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix Linuxdoc comment
From: Jeff Dike <jdike@addtoit.com>

A linuxdoc comment had fallen out of date - it refers to an argument which no
longer exists.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/handle.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/irq/handle.c~fix-linuxdoc-comment kernel/irq/handle.c
--- a/kernel/irq/handle.c~fix-linuxdoc-comment
+++ a/kernel/irq/handle.c
@@ -22,7 +22,6 @@
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
  * @desc:      description of the interrupt
- * @regs:      pointer to a register structure
  *
  * Handles spurious and unhandled IRQ's. It also prints a debugmessage.
  */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
