From: akpm@linux-foundation.org
Subject: + whitespace-fixes-audit-filtering.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:44 -0700
Message-ID: <200707210018.l6L0IioQ023861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757629AbXGUAUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, dwmw2@infradead.org


The patch titled
     whitespace fixes: audit filtering
has been added to the -mm tree.  Its filename is
     whitespace-fixes-audit-filtering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: audit filtering
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditfilter.c~whitespace-fixes-audit-filtering kernel/auditfilter.c
--- a/kernel/auditfilter.c~whitespace-fixes-audit-filtering
+++ a/kernel/auditfilter.c
@@ -1491,7 +1491,7 @@ int audit_receive_filter(int type, int p
 		 * auditctl to read from it... which isn't ever going to
 		 * happen if we're actually running in the context of auditctl
 		 * trying to _send_ the stuff */
-		 
+
 		dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
 		if (!dest)
 			return -ENOMEM;
@@ -1667,7 +1667,7 @@ int audit_filter_type(int type)
 {
 	struct audit_entry *e;
 	int result = 0;
-	
+
 	rcu_read_lock();
 	if (list_empty(&audit_filter_list[AUDIT_FILTER_TYPE]))
 		goto unlock_and_return;
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
