From: akpm@linux-foundation.org
Subject: [merged] documentation-submitchecklist-add-rcu-debug-config-options.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:46 -0700
Message-ID: <201107260755.p6Q7tnnc003493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434Ab1GZH4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/SubmitChecklist: add RCU debug config options
has been removed from the -mm tree.  Its filename was
     documentation-submitchecklist-add-rcu-debug-config-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/SubmitChecklist: add RCU debug config options
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

There have been persistent lockdep RCU splats, indicating that submitters
are not testing with CONFIG_PROVE_RCU.  Add this config option to the list
in Documentation/SubmitChecklist.  Also add CONFIG_DEBUG_OBJECTS_RCU_HEAD
for good measure.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/SubmitChecklist~documentation-submitchecklist-add-rcu-debug-config-options Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~documentation-submitchecklist-add-rcu-debug-config-options
+++ a/Documentation/SubmitChecklist
@@ -53,8 +53,8 @@ kernel patches.
 
 12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
     CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
-    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP all simultaneously
-    enabled.
+    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP, CONFIG_PROVE_RCU
+    and CONFIG_DEBUG_OBJECTS_RCU_HEAD all simultaneously enabled.
 
 13: Has been build- and runtime tested with and without CONFIG_SMP and
     CONFIG_PREEMPT.
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch

