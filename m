From: akpm@linux-foundation.org
Subject: - kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:32 -0700
Message-ID: <200710192254.l9JMsW7m024542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764343AbXJSXFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     kernel/fork.c: remove unneeded variable initialization in copy_process()
has been removed from the -mm tree.  Its filename was
     kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/fork.c: remove unneeded variable initialization in copy_process()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This initialization of is not needed so just remove it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~kernel-forkc-remove-unneeded-variable-initialization-in-copy_process kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-remove-unneeded-variable-initialization-in-copy_process
+++ a/kernel/fork.c
@@ -978,7 +978,7 @@ static struct task_struct *copy_process(
 					struct pid *pid)
 {
 	int retval;
-	struct task_struct *p = NULL;
+	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
