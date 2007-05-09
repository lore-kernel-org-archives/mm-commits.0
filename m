From: akpm@linux-foundation.org
Subject: - doc-fix-oops-tracing-duplicate.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:08 -0700
Message-ID: <200705090252.l492q8Vd009540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032202AbXEICwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc: fix oops-tracing duplicate
has been removed from the -mm tree.  Its filename was
     doc-fix-oops-tracing-duplicate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: doc: fix oops-tracing duplicate
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Remove duplicate 'U' entry -- fix mis-merge.

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    3 ---
 1 file changed, 3 deletions(-)

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

origin.patch
git-ia64.patch
git-kvm.patch
i386-irq-kill-irq-compression.patch
xfs-fix-unmount-race.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
frame-buffer-geforce-7300-gt.patch
