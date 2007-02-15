From: akpm@linux-foundation.org
Subject: - sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:58 -0800
Message-ID: <200702150849.l1F8nwDa025172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40205 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965505AbXBOIud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: register the sysctl number used by the arlan driver
has been removed from the -mm tree.  Its filename was
     sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: register the sysctl number used by the arlan driver
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/arlan-proc.c |    2 +-
 include/linux/sysctl.h            |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/arlan-proc.c~sysctl-register-the-sysctl-number-used-by-the-arlan-driver drivers/net/wireless/arlan-proc.c
--- a/drivers/net/wireless/arlan-proc.c~sysctl-register-the-sysctl-number-used-by-the-arlan-driver
+++ a/drivers/net/wireless/arlan-proc.c
@@ -1216,7 +1216,7 @@ static ctl_table arlan_table[MAX_ARLANS 
 static ctl_table arlan_root_table[] =
 {
 	{
-		.ctl_name	= 254,
+		.ctl_name	= CTL_ARLAN,
 		.procname	= "arlan",
 		.maxlen		= 0,
 		.mode		= 0555,
diff -puN include/linux/sysctl.h~sysctl-register-the-sysctl-number-used-by-the-arlan-driver include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-register-the-sysctl-number-used-by-the-arlan-driver
+++ a/include/linux/sysctl.h
@@ -70,6 +70,7 @@ enum
 	CTL_BUS=8,		/* Busses */
 	CTL_ABI=9,		/* Binary emulation */
 	CTL_CPU=10,		/* CPU stuff (speed scaling, etc) */
+	CTL_ARLAN=254,		/* arlan wireless driver */
 	CTL_APPLDATA=2120,	/* s390 appldata */
 	CTL_S390DBF=5677,	/* s390 debug */
 	CTL_SUNRPC=7249,	/* sunrpc debug */
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
