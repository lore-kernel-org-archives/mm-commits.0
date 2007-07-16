From: akpm@linux-foundation.org
Subject: - kerneldoc-fix-in-audit_core_dumps.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:09 -0700
Message-ID: <200707162057.l6GKv9g9002160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758811AbXGPVLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     kerneldoc fix in audit_core_dumps
has been removed from the -mm tree.  Its filename was
     kerneldoc-fix-in-audit_core_dumps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kerneldoc fix in audit_core_dumps
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix parameter name in audit_core_dumps for kerneldoc.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/auditsc.c~kerneldoc-fix-in-audit_core_dumps kernel/auditsc.c
--- a/kernel/auditsc.c~kerneldoc-fix-in-audit_core_dumps
+++ a/kernel/auditsc.c
@@ -2037,7 +2037,7 @@ int __audit_signal_info(int sig, struct 
 
 /**
  * audit_core_dumps - record information about processes that end abnormally
- * @sig: signal value
+ * @signr: signal value
  *
  * If a process ends with a core dump, something fishy is going on and we
  * should record the event for investigation.
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

origin.patch
