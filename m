From: akpm@linux-foundation.org
Subject: - whitespace-fixes-audit-filtering.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:38 -0700
Message-ID: <200710190343.l9J3hcVY013078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932841AbXJSD4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: audit filtering
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-audit-filtering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: audit filtering
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditfilter.c~whitespace-fixes-audit-filtering kernel/auditfilter.c
--- a/kernel/auditfilter.c~whitespace-fixes-audit-filtering
+++ a/kernel/auditfilter.c
@@ -1498,7 +1498,7 @@ int audit_receive_filter(int type, int p
 		 * auditctl to read from it... which isn't ever going to
 		 * happen if we're actually running in the context of auditctl
 		 * trying to _send_ the stuff */
-		 
+
 		dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
 		if (!dest)
 			return -ENOMEM;
@@ -1678,7 +1678,7 @@ int audit_filter_type(int type)
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

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
