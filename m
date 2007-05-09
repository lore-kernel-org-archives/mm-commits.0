From: akpm@linux-foundation.org
Subject: - make-vm-statistics-update-interval-configurable-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 02:04:08 -0700
Message-ID: <200705090904.l49948Sf018715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbXEIJEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     make-vm-statistics-update-interval-configurable-fix
has been removed from the -mm tree.  Its filename was
     make-vm-statistics-update-interval-configurable-fix.patch

This patch was dropped because it was folded into make-vm-statistics-update-interval-configurable.patch

------------------------------------------------------
Subject: make-vm-statistics-update-interval-configurable-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sysctl.h~make-vm-statistics-update-interval-configurable-fix include/linux/sysctl.h
diff -puN kernel/sysctl.c~make-vm-statistics-update-interval-configurable-fix kernel/sysctl.c
--- a/kernel/sysctl.c~make-vm-statistics-update-interval-configurable-fix
+++ a/kernel/sysctl.c
@@ -860,7 +860,7 @@ static ctl_table vm_table[] = {
 #endif
 #ifdef CONFIG_SMP
 	{
-		.ctl_name	= VM_STAT_INTERVAL,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "stat_interval",
 		.data		= &sysctl_stat_interval,
 		.maxlen		= sizeof(sysctl_stat_interval),
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
make-vm-statistics-update-interval-configurable.patch
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
