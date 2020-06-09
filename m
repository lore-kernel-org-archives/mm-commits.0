From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 09 Jun 2020 09:56:26 -0700
Message-ID: <20200609165626.6gaMq2928%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbgFIQ41 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 12:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/ptrace_32.c |   14 --------------
 security/apparmor/label.c     |    3 ---
 2 files changed, 17 deletions(-)

--- a/arch/sparc/kernel/ptrace_32.c~linux-next-git-rejects
+++ a/arch/sparc/kernel/ptrace_32.c
@@ -167,26 +167,12 @@ static int genregs32_set(struct task_str
 	if (ret || !count)
 		return ret;
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-<<<<<<< HEAD
-				 &regs->npc,
-				 34 * sizeof(u32), 35 * sizeof(u32));
-	if (ret || !count)
-		return ret;
-	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &regs->y,
-				 35 * sizeof(u32), 36 * sizeof(u32));
-	if (ret || !count)
-		return ret;
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 36 * sizeof(u32), 38 * sizeof(u32));
-=======
 				 &regs->y,
 				 34 * sizeof(u32), 35 * sizeof(u32));
 	if (ret || !count)
 		return ret;
 	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
 					 35 * sizeof(u32), 38 * sizeof(u32));
->>>>>>> linux-next/akpm-base
 }
 
 static int fpregs32_get(struct task_struct *target,
--- a/security/apparmor/label.c~linux-next-git-rejects
+++ a/security/apparmor/label.c
@@ -333,10 +333,7 @@ void aa_label_destroy(struct aa_label *l
 	}
 	aa_free_secid(label->secid);
 
-<<<<<<< HEAD
-=======
 	aa_put_proxy(label->proxy);
->>>>>>> linux-next/akpm-base
 	label->proxy = (struct aa_proxy *) PROXY_POISON + 1;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
