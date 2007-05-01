From: akpm@linux-foundation.org
Subject: + doc-fix-oops-tracing-duplicate.patch added to -mm tree
Date: Tue, 01 May 2007 15:26:25 -0700
Message-ID: <200705012226.l41MQP1E008112@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbXEAW0h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 18:26:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, randy.dunlap@oracle.com


The patch titled
     doc: fix oops-tracing duplicate
has been added to the -mm tree.  Its filename is
     doc-fix-oops-tracing-duplicate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: doc: fix oops-tracing duplicate
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Remove duplicate 'U' entry -- fix mis-merge.

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    3 ---
 1 files changed, 3 deletions(-)

diff -puN Documentation/oops-tracing.txt~doc-fix-oops-tracing-duplicate Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~doc-fix-oops-tracing-duplicate
+++ a/Documentation/oops-tracing.txt
@@ -234,9 +234,6 @@ characters, each representing a particul
   6: 'B' if a page-release function has found a bad page reference or
      some unexpected page flags.
 
-  7: 'U' if a user specifically requested that the Tainted flag be set,
-     ' ' otherwise.
-
   7: 'U' if a user or user application specifically requested that the
      Tainted flag be set, ' ' otherwise.
 
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

git-ia64.patch
git-input.patch
git-kvm.patch
i386-irq-kill-irq-compression.patch
xfs-fix-unmount-race.patch
doc-fix-oops-tracing-duplicate.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
