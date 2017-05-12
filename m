From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 12 May 2017 12:35:41 -0700
Message-ID: <20170512193541.xGTp0CgP6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757272AbdELTfn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 15:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c~linux-next-git-rejects drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c~linux-next-git-rejects
+++ a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1170,11 +1170,8 @@ static struct ibmvscsis_cmd *ibmvscsis_g
 		cmd = list_first_entry_or_null(&vscsi->free_cmd,
 					       struct ibmvscsis_cmd, list);
 		if (cmd) {
-<<<<<<< HEAD
-=======
 			if (cmd->abort_cmd)
 				cmd->abort_cmd = NULL;
->>>>>>> linux-next/akpm-base
 			cmd->flags &= ~(DELAY_SEND);
 			list_del(&cmd->list);
 			cmd->iue = iue;
@@ -1779,10 +1776,7 @@ static void ibmvscsis_send_messages(stru
 				if (cmd->abort_cmd) {
 					retry = true;
 					cmd->abort_cmd->flags &= ~(DELAY_SEND);
-<<<<<<< HEAD
-=======
 					cmd->abort_cmd = NULL;
->>>>>>> linux-next/akpm-base
 				}
 
 				/*
diff -puN include/linux/namei.h~linux-next-git-rejects include/linux/namei.h
--- a/include/linux/namei.h~linux-next-git-rejects
+++ a/include/linux/namei.h
@@ -45,11 +45,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_ROOT		0x2000
 #define LOOKUP_EMPTY		0x4000
 #define LOOKUP_DOWN		0x8000
-<<<<<<< HEAD
-=======
 
 #define LOOKUP_NO_JUMPS		0x10000
->>>>>>> linux-next/akpm-base
 
 extern int path_pts(struct path *path);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
tigran-has-moved.patch
mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

