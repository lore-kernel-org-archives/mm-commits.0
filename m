From: akpm@linux-foundation.org
Subject: - sysctl-remove-insert_at_head-from-register_sysctl-fix.patch removed from -mm tree
Date: Thu, 01 Mar 2007 22:26:34 -0800
Message-ID: <200703020628.l226S9qv002261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45065 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422965AbXCBG2L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 01:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-remove-insert_at_head-from-register_sysctl fix
has been removed from the -mm tree.  Its filename was
     sysctl-remove-insert_at_head-from-register_sysctl-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: sysctl-remove-insert_at_head-from-register_sysctl fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

kernel/sched.c: In function 'init_sched_domain_sysctl':
kernel/sched.c:5465: error: too many arguments to function 'register_sysctl_table'

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sysctl-remove-insert_at_head-from-register_sysctl-fix kernel/sched.c
--- a/kernel/sched.c~sysctl-remove-insert_at_head-from-register_sysctl-fix
+++ a/kernel/sched.c
@@ -5519,7 +5519,7 @@ static void init_sched_domain_sysctl(voi
 		entry->mode = 0755;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
-	sd_sysctl_header = register_sysctl_table(sd_ctl_root, 0);
+	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
 }
 #else
 static void init_sched_domain_sysctl(void)
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
reiser4-configh.patch
