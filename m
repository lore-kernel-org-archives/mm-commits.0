From: akpm@linux-foundation.org
Subject: [merged] sh64-kernel-remove-useless-variable-regs.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:37:00 -0800
Message-ID: <5283e2ec.j9tTT/sNQNIV/mKK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3KMUhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lethal@linux-sh.org, gang.chen@asianux.com

Subject: [merged] sh64-kernel-remove-useless-variable-regs.patch removed from -mm tree
To: gang.chen@asianux.com,lethal@linux-sh.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:00 -0800


The patch titled
     Subject: sh64: kernel: remove useless variable 'regs'
has been removed from the -mm tree.  Its filename was
     sh64-kernel-remove-useless-variable-regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: sh64: kernel: remove useless variable 'regs'

Remove useless variable 'regs' to avoid the related warnings (warning is
treated as error).

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/process_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/process_64.c~sh64-kernel-remove-useless-variable-regs arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~sh64-kernel-remove-useless-variable-regs
+++ a/arch/sh/kernel/process_64.c
@@ -374,7 +374,7 @@ asmlinkage void ret_from_kernel_thread(v
 int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long arg, struct task_struct *p)
 {
-	struct pt_regs *childregs, *regs = current_pt_regs();
+	struct pt_regs *childregs;
 
 #ifdef CONFIG_SH_FPU
 	/* can't happen for a kernel thread */
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch
linux-next.patch

