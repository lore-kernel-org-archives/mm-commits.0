From: akpm@linux-foundation.org
Subject: + utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch added to -mm tree
Date: Thu, 15 Feb 2007 01:19:56 -0800
Message-ID: <200702150919.l1F9JuKW025807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40883 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965322AbXBOJT5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 04:19:57 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1F9JuhB005351
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2007 01:19:57 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     a
has been added to the -mm tree.  Its filename is
     utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: a
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ptrace.c~utrace-vs-reduce-size-of-task_struct-on-64-bit-machines kernel/ptrace.c
--- a/kernel/ptrace.c~utrace-vs-reduce-size-of-task_struct-on-64-bit-machines
+++ a/kernel/ptrace.c
@@ -1107,7 +1107,7 @@ found:
 	BUG_ON(state->parent != tsk);
 	rcu_read_unlock();
 
-	pr_debug("%d ptrace_do_wait (%d) found %d code %x (%lu)\n",
+	pr_debug("%d ptrace_do_wait (%d) found %d code %x (%u)\n",
 		 current->pid, tsk->pid, p->pid, exit_code, p->exit_state);
 
 	if (p->exit_state) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
git-block-vs-ext4-ext4-delayed-allocation.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
