From: akpm@linux-foundation.org
Subject: [obsolete] arch-alpha-kernel-systblss-remove-debug-check.patch
 removed from -mm tree
Date: Mon, 26 Sep 2016 13:42:06 -0700
Message-ID: <57e9881e.sMUvaBQ9qg9rqaV8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44747 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933587AbcIZUmH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 16:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/alpha/kernel/systbls.S: remove debug check
has been removed from the -mm tree.  Its filename was
     arch-alpha-kernel-systblss-remove-debug-check.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/alpha/kernel/systbls.S: remove debug check

-mm only patch, I guess.

My old gas-2.16.1 says

arch/alpha/kernel/systbls.S: Assembler messages:
arch/alpha/kernel/systbls.S:523: Error: non-constant expression in ".if" statement
arch/alpha/kernel/systbls.S:524: Error: .err encountered

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/systbls.S |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/alpha/kernel/systbls.S~arch-alpha-kernel-systblss-remove-debug-check arch/alpha/kernel/systbls.S
--- a/arch/alpha/kernel/systbls.S~arch-alpha-kernel-systblss-remove-debug-check
+++ a/arch/alpha/kernel/systbls.S
@@ -536,7 +536,3 @@ sys_call_table:
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
 
-/* Remember to update everything, kids.  */
-.ifne (. - sys_call_table) - (NR_SYSCALLS * 8)
-.err
-.endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

