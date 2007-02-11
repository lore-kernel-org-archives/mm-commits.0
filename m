From: akpm@linux-foundation.org
Subject: - uml-const-a-variable.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:11 -0800
Message-ID: <200702112249.l1BMnBuC015702@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59825 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbXBKWtN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: const a variable
has been removed from the -mm tree.  Its filename was
     uml-const-a-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: const a variable
From: Jeff Dike <jdike@addtoit.com>

kstack_depth_to_print can be made const.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/sysrq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/sysrq.c~uml-const-a-variable arch/um/kernel/sysrq.c
--- a/arch/um/kernel/sysrq.c~uml-const-a-variable
+++ a/arch/um/kernel/sysrq.c
@@ -50,7 +50,7 @@ void dump_stack(void)
 EXPORT_SYMBOL(dump_stack);
 
 /*Stolen from arch/i386/kernel/traps.c */
-static int kstack_depth_to_print = 24;
+static const int kstack_depth_to_print = 24;
 
 /* This recently started being used in arch-independent code too, as in
  * kernel/sched.c.*/
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
