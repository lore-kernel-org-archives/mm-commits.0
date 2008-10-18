From: akpm@linux-foundation.org
Subject: - documentation-explain-memory-barriers.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:20 -0700
Message-ID: <200810182312.m9INCKmW027969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbYJRXMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     documentation: explain memory barriers
has been removed from the -mm tree.  Its filename was
     documentation-explain-memory-barriers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: explain memory barriers
From: Randy Dunlap <randy.dunlap@oracle.com>

We want all uses of memory barriers to be explained in the source code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    3 +++
 1 file changed, 3 insertions(+)

diff -puN Documentation/SubmitChecklist~documentation-explain-memory-barriers Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~documentation-explain-memory-barriers
+++ a/Documentation/SubmitChecklist
@@ -85,3 +85,6 @@ kernel patches.
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
     changes in the VM, VFS, and other subsystems.
+
+24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment in the
+    source code that explains the logic of what they are doing and why.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch

