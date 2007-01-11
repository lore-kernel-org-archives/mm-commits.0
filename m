From: akpm@osdl.org
Subject: - kvm-add-vm-exit-profiling-fix.patch removed from -mm tree
Date: Wed, 10 Jan 2007 23:08:07 -0800
Message-ID: <200701110708.l0B787UU019008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965315AbXAKHIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:08:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm-add-vm-exit-profiling fix
has been removed from the -mm tree.  Its filename was
     kvm-add-vm-exit-profiling-fix.patch

This patch was dropped because it was folded into kvm-add-vm-exit-profiling.patch

------------------------------------------------------
Subject: kvm-add-vm-exit-profiling fix
From: Ingo Molnar <mingo@elte.hu>

Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/profile.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/profile.c~kvm-add-vm-exit-profiling-fix kernel/profile.c
--- a/kernel/profile.c~kvm-add-vm-exit-profiling-fix
+++ a/kernel/profile.c
@@ -331,6 +331,7 @@ out:
 	local_irq_restore(flags);
 	put_cpu();
 }
+EXPORT_SYMBOL_GPL(profile_hits);
 
 static int __devinit profile_cpu_callback(struct notifier_block *info,
 					unsigned long action, void *__cpu)
_

Patches currently in -mm which might be from mingo@elte.hu are

sched-tasks-cannot-run-on-cpus-onlined-after-boot.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
kvm-add-vm-exit-profiling.patch
kvm-add-vm-exit-profiling-fix.patch
revert-bd_mount_mutex-back-to-a-semaphore.patch
