From: akpm@linux-foundation.org
Subject: [merged] exit-remove-unneeded-declaration-of-exit_mm.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:59 -0800
Message-ID: <56a162ef.1IQ9Gelzt/DQ+cGs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbcAUXAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:00:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 0x7f454c46@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: remove unneeded declaration of exit_mm()
has been removed from the -mm tree.  Its filename was
     exit-remove-unneeded-declaration-of-exit_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: exit: remove unneeded declaration of exit_mm()

Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/exit.c~exit-remove-unneeded-declaration-of-exit_mm kernel/exit.c
--- a/kernel/exit.c~exit-remove-unneeded-declaration-of-exit_mm
+++ a/kernel/exit.c
@@ -59,8 +59,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-static void exit_mm(struct task_struct *tsk);
