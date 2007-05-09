From: akpm@linux-foundation.org
Subject: - make-cancel_rearming_delayed_work-reliable-spelling.patch removed from -mm tree
Date: Wed, 09 May 2007 02:00:30 -0700
Message-ID: <200705090900.l4990UKC018648@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610AbXEIJA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dgc@sgi.com, dhowells@redhat.com, ego@in.ibm.com, jarkao2@o2.pl, oleg@tv-sign.ru, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     make-cancel_rearming_delayed_work-reliable-spelling
has been removed from the -mm tree.  Its filename was
     make-cancel_rearming_delayed_work-reliable-spelling.patch

This patch was dropped because it was folded into make-cancel_rearming_delayed_work-reliable.patch

------------------------------------------------------
Subject: make-cancel_rearming_delayed_work-reliable-spelling
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Chinner <dgc@sgi.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~make-cancel_rearming_delayed_work-reliable-spelling kernel/workqueue.c
--- a/kernel/workqueue.c~make-cancel_rearming_delayed_work-reliable-spelling
+++ a/kernel/workqueue.c
@@ -389,7 +389,7 @@ void fastcall flush_workqueue(struct wor
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 /*
- * Upon a successfull return, the caller "owns" WORK_STRUCT_PENDING bit,
+ * Upon a successful return, the caller "owns" WORK_STRUCT_PENDING bit,
  * so this work can't be re-armed in any way.
  */
 static int try_to_grab_pending(struct work_struct *work)
@@ -474,7 +474,7 @@ static void wait_on_work(struct work_str
  *
  * It is possible to use this function if the work re-queues itself. It can
  * cancel the work even if it migrates to another workqueue, however in that
- * case it only garantees that work->func() has completed on the last queued
+ * case it only guarantees that work->func() has completed on the last queued
  * workqueue.
  *
  * The caller must ensure that workqueue_struct on which this work was last
@@ -493,7 +493,7 @@ EXPORT_SYMBOL_GPL(cancel_work_sync);
  * cancel_rearming_delayed_work - reliably kill off a delayed work.
  * @dwork: the delayed work struct
  *
- * It is possible to use this function if dwork rearms itself via queue_work()
+ * It is possible to use this function if @dwork rearms itself via queue_work()
  * or queue_delayed_work(). See also the comment for cancel_work_sync().
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)
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
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
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
