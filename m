From: akpm@linux-foundation.org
Subject: [merged] kprobes-cleanup-comment-style-in-kprobesh.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:20 -0700
Message-ID: <200904071907.n37J7Kkk011271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583AbZDGTnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     kprobes: cleanup comment style in kprobes.h
has been removed from the -mm tree.  Its filename was
     kprobes-cleanup-comment-style-in-kprobesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: cleanup comment style in kprobes.h
From: Masami Hiramatsu <mhiramat@redhat.com>

Fix comment style in kprobes.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-cleanup-comment-style-in-kprobesh include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-cleanup-comment-style-in-kprobesh
+++ a/include/linux/kprobes.h
@@ -94,12 +94,16 @@ struct kprobe {
 	/* Called after addr is executed, unless... */
 	kprobe_post_handler_t post_handler;
 
-	/* ... called if executing addr causes a fault (eg. page fault).
-	 * Return 1 if it handled fault, otherwise kernel will see it. */
+	/*
+	 * ... called if executing addr causes a fault (eg. page fault).
+	 * Return 1 if it handled fault, otherwise kernel will see it.
+	 */
 	kprobe_fault_handler_t fault_handler;
 
-	/* ... called if breakpoint trap occurs in probe handler.
-	 * Return 1 if it handled break, otherwise kernel will see it. */
+	/*
+	 * ... called if breakpoint trap occurs in probe handler.
+	 * Return 1 if it handled break, otherwise kernel will see it.
+	 */
 	kprobe_break_handler_t break_handler;
 
 	/* Saved opcode (which has been replaced with breakpoint) */
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

