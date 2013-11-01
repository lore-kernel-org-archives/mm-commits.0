From: akpm@linux-foundation.org
Subject: [merged]
 arch-arc-kernel-stacktracec-export-save_stack_trace.patch removed from -mm
 tree
Date: Fri, 01 Nov 2013 16:16:11 -0700
Message-ID: <5274363b.M9Pc6erjlVqeCrna%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3KAXQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 19:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, gang.chen@asianux.com

Subject: [merged] arch-arc-kernel-stacktracec-export-save_stack_trace.patch removed from -mm tree
To: gang.chen@asianux.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 16:16:11 -0700


The patch titled
     Subject: arch/arc/kernel/stacktrace.c: export save_stack_trace()
has been removed from the -mm tree.  Its filename was
     arch-arc-kernel-stacktracec-export-save_stack_trace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: arch/arc/kernel/stacktrace.c: export save_stack_trace()

allmodconfig:

    MODPOST 2994 modules
  ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
  ERROR: "save_stack_trace" [drivers/md/persistent-data/dm-persistent-data.ko] undefined!

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/stacktrace.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arc/kernel/stacktrace.c~arch-arc-kernel-stacktracec-export-save_stack_trace arch/arc/kernel/stacktrace.c
--- a/arch/arc/kernel/stacktrace.c~arch-arc-kernel-stacktracec-export-save_stack_trace
+++ a/arch/arc/kernel/stacktrace.c
@@ -244,4 +244,5 @@ void save_stack_trace(struct stack_trace
 {
 	arc_unwind_core(current, NULL, __collect_all, trace);
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
 #endif
_

Patches currently in -mm which might be from gang.chen@asianux.com are

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch
kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch
kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch
kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch
linux-next.patch

