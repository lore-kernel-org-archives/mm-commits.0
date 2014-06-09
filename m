From: akpm@linux-foundation.org
Subject: [merged] kernel-seccompc-kernel-doc-warning-fix.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:38:23 -0700
Message-ID: <53960d2f.UZCSZi4+ZAMJ3Txx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, fabf@skynet.be

Subject: [merged] kernel-seccompc-kernel-doc-warning-fix.patch removed from -mm tree
To: fabf@skynet.be,davem@davemloft.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:23 -0700


The patch titled
     Subject: kernel/seccomp.c: kernel-doc warning fix
has been removed from the -mm tree.  Its filename was
     kernel-seccompc-kernel-doc-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/seccomp.c: kernel-doc warning fix

+ fix small typo

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/seccomp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/seccomp.c~kernel-seccompc-kernel-doc-warning-fix kernel/seccomp.c
--- a/kernel/seccomp.c~kernel-seccompc-kernel-doc-warning-fix
+++ a/kernel/seccomp.c
@@ -39,7 +39,7 @@
  *         is only needed for handling filters shared across tasks.
  * @prev: points to a previously installed, or inherited, filter
  * @len: the number of instructions in the program
- * @insns: the BPF program instructions to evaluate
+ * @insnsi: the BPF program instructions to evaluate
  *
  * seccomp_filter objects are organized in a tree linked via the @prev
  * pointer.  For any task, it appears to be a singly-linked list starting
@@ -220,7 +220,7 @@ static long seccomp_attach_filter(struct
 		return -ENOMEM;
 
 	/*
-	 * Installing a seccomp filter requires that the task have
+	 * Installing a seccomp filter requires that the task has
 	 * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
 	 * This avoids scenarios where unprivileged tasks can affect the
 	 * behavior of privileged children.
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

