From: akpm@linux-foundation.org
Subject: - improve-cgroup-printks-fix.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:41:01 -0800
Message-ID: <200711150041.lAF0f1jJ001858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbXKOAlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, diegocg@gmail.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     improve-cgroup-printks-fix
has been removed from the -mm tree.  Its filename was
     improve-cgroup-printks-fix.patch

This patch was dropped because it was folded into improve-cgroup-printks.patch

------------------------------------------------------
Subject: improve-cgroup-printks-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Diego Calleja <diegocg@gmail.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~improve-cgroup-printks-fix kernel/cgroup.c
--- a/kernel/cgroup.c~improve-cgroup-printks-fix
+++ a/kernel/cgroup.c
@@ -2198,7 +2198,8 @@ static void cgroup_init_subsys(struct cg
 {
 	struct cgroup_subsys_state *css;
 	struct list_head *l;
-	printk("Initializing cgroup subsys %s\n", ss->name);
+
+	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
 	/* Create the top cgroup state for this subsystem */
 	ss->root = &rootnode;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
improve-cgroup-printks.patch
improve-cgroup-printks-fix.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch
