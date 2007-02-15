From: akpm@linux-foundation.org
Subject: - sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:48:25 -0800
Message-ID: <200702150848.l1F8mPjq025047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40326 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965548AbXBOIvm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:51:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: netrom: remove unnecessary insert_at_head flag
has been removed from the -mm tree.  Its filename was
     sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: netrom: remove unnecessary insert_at_head flag
From: Eric W. Biederman <ebiederm@xmission.com>

The sysctl numbers used are unique so setting the insert_at_head flag serves
no semantic purpose, so it is just confusing.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netrom/sysctl_net_netrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/netrom/sysctl_net_netrom.c~sysctl-netrom-remove-unnecessary-insert_at_head-flag net/netrom/sysctl_net_netrom.c
--- a/net/netrom/sysctl_net_netrom.c~sysctl-netrom-remove-unnecessary-insert_at_head-flag
+++ a/net/netrom/sysctl_net_netrom.c
@@ -192,7 +192,7 @@ static ctl_table nr_root_table[] = {
 
 void __init nr_register_sysctl(void)
 {
-	nr_table_header = register_sysctl_table(nr_root_table, 1);
+	nr_table_header = register_sysctl_table(nr_root_table, 0);
 }
 
 void nr_unregister_sysctl(void)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
