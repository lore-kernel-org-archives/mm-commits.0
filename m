From: akpm@osdl.org
Subject: + rcu-debug-trace-for-rcu-fix-2.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:18:38 -0800
Message-ID: <200701300118.l0U1Ic9Z005393@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXA3BSq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, bero@arklinux.org, dipankar@in.ibm.com, frederik.deweerdt@gmail.com, paulmck@in.ibm.com


The patch titled
     rcu-debug-trace-for-rcu-fix 2
has been added to the -mm tree.  Its filename is
     rcu-debug-trace-for-rcu-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcu-debug-trace-for-rcu-fix 2
From: Frederik Deweerdt <deweerdt@free.fr>

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Bernhard Rosenkraenzer <bero@arklinux.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Paul McKenney <paulmck@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/rcupreempt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-debug-trace-for-rcu-fix-2 kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-debug-trace-for-rcu-fix-2
+++ a/kernel/rcupreempt.c
@@ -649,7 +649,7 @@ EXPORT_SYMBOL_GPL(rcupreempt_data_comple
 EXPORT_SYMBOL_GPL(rcupreempt_flip_flag);
 EXPORT_SYMBOL_GPL(rcupreempt_mb_flag);
 EXPORT_SYMBOL_GPL(rcupreempt_try_flip_state_name);
-#endif /* #ifdef RCU_TRACE */
+#endif /* #ifdef CONFIG_RCU_TRACE */
 
 EXPORT_SYMBOL_GPL(call_rcu);
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
_

Patches currently in -mm which might be from deweerdt@free.fr are

remove-tcp-header-from-tcp_v4_check-take-2.patch
disable-init-initramfsc-updated-fix.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-user-ns-unshare.patch
rcu-debug-trace-for-rcu-fix-2.patch
reiser4-sb_sync_inodes-fix.patch
