From: akpm@linux-foundation.org
Subject: - git-parisc-fixup.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:36:54 -0800
Message-ID: <200702282336.l1SNas5l030570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbXB1Xg5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:36:57 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1SNathB000490
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2007 15:36:55 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-parisc-fixup
has been removed from the -mm tree.  Its filename was
     git-parisc-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-parisc-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/sched.h~git-parisc-fixup include/linux/sched.h
--- a/include/linux/sched.h~git-parisc-fixup
+++ a/include/linux/sched.h
@@ -1329,12 +1329,6 @@ extern int kill_pid_info(int sig, struct
 extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
-<<<<<<< HEAD/include/linux/sched.h
-=======
-extern int __kill_pg_info(int sig, struct siginfo *info, pid_t pgrp);
-extern int kill_pg_info(int, struct siginfo *, pid_t);
-extern int kill_proc_info(int, struct siginfo *, pid_t);
->>>>>>> /include/linux/sched.h
 extern void do_notify_parent(struct task_struct *, int);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-md-accel-vs-md.patch
git-mips-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
