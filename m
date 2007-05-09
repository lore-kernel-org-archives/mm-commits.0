From: akpm@linux-foundation.org
Subject: - rename-thread_info-to-stack-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 02:05:10 -0700
Message-ID: <200705090905.l4995Avu018733@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754640AbXEIJFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     rename-thread_info-to-stack-fix
has been removed from the -mm tree.  Its filename was
     rename-thread_info-to-stack-fix.patch

This patch was dropped because it was folded into rename-thread_info-to-stack.patch

------------------------------------------------------
Subject: rename-thread_info-to-stack-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86_64/system.h~rename-thread_info-to-stack-fix include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~rename-thread_info-to-stack-fix
+++ a/include/asm-x86_64/system.h
@@ -39,7 +39,7 @@
 		       [threadrsp] "i" (offsetof(struct task_struct, thread.rsp)), \
 		       [ti_flags] "i" (offsetof(struct thread_info, flags)),\
 		       [tif_fork] "i" (TIF_FORK),			  \
-		       [thread_info] "i" (offsetof(struct task_struct, thread_info)), \
+		       [thread_info] "i" (offsetof(struct task_struct, stack)), \
 		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))   \
 		     : "memory", "cc" __EXTRA_CLOBBER)
     
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
rename-thread_info-to-stack.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
