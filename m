From: akpm@linux-foundation.org
Subject: - fixing-the-warning-in-cgroupc.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:13 -0700
Message-ID: <200710242141.l9OLfDG5013933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbXJXVlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     Fix warning in cgroup.c
has been removed from the -mm tree.  Its filename was
     fixing-the-warning-in-cgroupc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix warning in cgroup.c
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

kernel/cgroup.c: In function `proc_cgroupstats_show':
kernel/cgroup.c:2405: warning: unused variable `root'

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~fixing-the-warning-in-cgroupc kernel/cgroup.c
--- a/kernel/cgroup.c~fixing-the-warning-in-cgroupc
+++ a/kernel/cgroup.c
@@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_opera
 static int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
 	int i;
-	struct cgroupfs_root *root;
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
 	mutex_lock(&cgroup_mutex);
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are
