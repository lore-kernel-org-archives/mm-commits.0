From: akpm@linux-foundation.org
Subject: [folded] kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:15:37 -0700
Message-ID: <20120531231537.C0F4FA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44423 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594Ab2EaXPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:15:39 -0400
Received: by eeit10 with SMTP id t10so83672eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:15:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anton.vorontsov@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-cpuc-document-clear_tasks_mm_cpumask-fix
has been removed from the -mm tree.  Its filename was
     kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch

This patch was dropped because it was folded into kernel-cpuc-document-clear_tasks_mm_cpumask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-cpuc-document-clear_tasks_mm_cpumask-fix

tweak comment: s/walks up/walks/, use 80 cols

Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/cpu.c~kernel-cpuc-document-clear_tasks_mm_cpumask-fix kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-document-clear_tasks_mm_cpumask-fix
+++ a/kernel/cpu.c
@@ -180,13 +180,13 @@ EXPORT_SYMBOL(unregister_cpu_notifier);
  * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
  * @cpu: a CPU id
  *
- * This function walks up all processes, finds a valid mm struct for
- * each one and then clears a corresponding bit in mm's cpumask. While
- * this all sounds trivial, there are various non-obvious corner cases,
- * which this function tries to solve in a safe manner.
+ * This function walks all processes, finds a valid mm struct for each one and
+ * then clears a corresponding bit in mm's cpumask.  While this all sounds
+ * trivial, there are various non-obvious corner cases, which this function
+ * tries to solve in a safe manner.
  *
- * Also note that the function uses a somewhat relaxed locking scheme,
- * so it may be called only for an already offlined CPU.
+ * Also note that the function uses a somewhat relaxed locking scheme, so it may
+ * be called only for an already offlined CPU.
  */
 void clear_tasks_mm_cpumask(int cpu)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

