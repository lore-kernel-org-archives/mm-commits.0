From: akpm@linux-foundation.org
Subject: + documentation-submitchecklist-add-rcu-debug-config-options.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:05:27 -0700
Message-ID: <201107052105.p65L5RtF023945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab1GEVF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com


The patch titled
     Documentation/SubmitChecklist: add RCU debug config options
has been added to the -mm tree.  Its filename is
     documentation-submitchecklist-add-rcu-debug-config-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
-    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP all simultaneously
-    enabled.
+    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP, CONFIG_PROVE_RCU,
+    CONFIG_DEBUG_OBJECTS_RCU_HEAD all simultaneously enabled.
 
 13: Has been build- and runtime tested with and without CONFIG_SMP and
     CONFIG_PREEMPT.
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

linux-next.patch
documentation-submitchecklist-add-rcu-debug-config-options.patch

