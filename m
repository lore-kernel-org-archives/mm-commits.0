From: akpm@linux-foundation.org
Subject: - whitespace-fixes-execution-domains.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:57 -0700
Message-ID: <200710190343.l9J3hv9x013107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbXJSDzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: execution domains
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-execution-domains.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: execution domains
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exec_domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exec_domain.c~whitespace-fixes-execution-domains kernel/exec_domain.c
--- a/kernel/exec_domain.c~whitespace-fixes-execution-domains
+++ a/kernel/exec_domain.c
@@ -57,7 +57,7 @@ lookup_exec_domain(u_long personality)
 {
 	struct exec_domain *	ep;
 	u_long			pers = personality(personality);
-		
+
 	read_lock(&exec_domains_lock);
 	for (ep = exec_domains; ep; ep = ep->next) {
 		if (pers >= ep->pers_low && pers <= ep->pers_high)
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
