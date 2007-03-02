From: akpm@linux-foundation.org
Subject: - add-mm-testing-in-submitchecklist.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:30 -0800
Message-ID: <200703020506.l2256UqV000802@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42292 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422716AbXCBFGe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add -mm testing in SubmitChecklist
has been removed from the -mm tree.  Its filename was
     add-mm-testing-in-submitchecklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add -mm testing in SubmitChecklist
From: Randy Dunlap <randy.dunlap@oracle.com>

Add -mm testing to SubmitChecklist.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/SubmitChecklist~add-mm-testing-in-submitchecklist Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~add-mm-testing-in-submitchecklist
+++ a/Documentation/SubmitChecklist
@@ -76,3 +76,7 @@ kernel patches.
 22: Newly-added code has been compiled with `gcc -W'.  This will generate
     lots of noise, but is good for finding bugs like "warning: comparison
     between signed and unsigned".
+
+23: Tested after it has been merged into the -mm patchset to make sure
+    that it still works with all of the other queued patches and various
+    changes in the VM, VFS, and other subsystems.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
phy-layer-add-kernel-doc-docbook.patch
fusion-kernel-doc-warning-fixes.patch
scripts-kernel-doc-whitespace-cleanup.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
