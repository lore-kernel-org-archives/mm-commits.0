From: akpm@linux-foundation.org
Subject: + kerneldoc-fix-in-audit_core_dumps.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:20:48 -0700
Message-ID: <200706191820.l5JIKmJk017883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759665AbXFSSVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, viro@zeniv.linux.org.uk


The patch titled
     kerneldoc fix in audit_core_dumps
has been added to the -mm tree.  Its filename is
     kerneldoc-fix-in-audit_core_dumps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kerneldoc fix in audit_core_dumps
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix parameter name in audit_core_dumps for kerneldoc.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/auditsc.c~kerneldoc-fix-in-audit_core_dumps kernel/auditsc.c
--- a/kernel/auditsc.c~kerneldoc-fix-in-audit_core_dumps
+++ a/kernel/auditsc.c
@@ -2040,7 +2040,7 @@ int __audit_signal_info(int sig, struct 
 
 /**
  * audit_core_dumps - record information about processes that end abnormally
- * @sig: signal value
+ * @signr: signal value
  *
  * If a process ends with a core dump, something fishy is going on and we
  * should record the event for investigation.
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

kerneldoc-fix-in-libata.patch
kerneldoc-fix-in-audit_core_dumps.patch
