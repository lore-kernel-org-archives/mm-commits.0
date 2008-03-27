From: akpm@linux-foundation.org
Subject: - kprobes-maintainers-update.patch removed from -mm tree
Date: Thu, 27 Mar 2008 00:42:25 -0700
Message-ID: <200803270742.m2R7gPW6024017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbYC0HnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 03:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: MAINTAINERS update
has been removed from the -mm tree.  Its filename was
     kprobes-maintainers-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: MAINTAINERS update
From: Masami Hiramatsu <mhiramat@redhat.com>

Add Masami Hiramatsu to kprobes maintainers

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~kprobes-maintainers-update MAINTAINERS
--- a/MAINTAINERS~kprobes-maintainers-update
+++ a/MAINTAINERS
@@ -2328,6 +2328,8 @@ P:	Anil S Keshavamurthy
 M:	anil.s.keshavamurthy@intel.com
 P:	David S. Miller
 M:	davem@davemloft.net
+P:	Masami Hiramatsu
+M:	mhiramat@redhat.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
listh-add-list_singleton-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

