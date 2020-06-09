From: akpm@linux-foundation.org
Subject: [folded-merged] xtensa-add-loglvl-to-show_trace-fix.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 20:11:02 -0700
Message-ID: <20200609031102.gFiAdW9rP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDLE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:11:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org, rppt@kernel.org


The patch titled
     Subject: xtensa-add-loglvl-to-show_trace-fix
has been removed from the -mm tree.  Its filename was
     xtensa-add-loglvl-to-show_trace-fix.patch

This patch was dropped because it was folded into xtensa-add-loglvl-to-show_trace.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: xtensa-add-loglvl-to-show_trace-fix

build fix

Link: http://lkml.kernel.org/r/20200511194534.GA1018386@kernel.org
Cc: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/kernel/traps.c~xtensa-add-loglvl-to-show_trace-fix
+++ a/arch/xtensa/kernel/traps.c
@@ -515,7 +515,7 @@ void show_stack(struct task_struct *task
 	print_hex_dump(KERN_INFO, " ", DUMP_PREFIX_NONE,
 		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
 		       sp, len, false);
-	show_trace(task, stack, KERN_INFO);
+	show_trace(task, sp, KERN_INFO);
 }
 
 DEFINE_SPINLOCK(die_lock);
_

Patches currently in -mm which might be from rppt@kernel.org are

xtensa-add-loglvl-to-show_trace.patch
