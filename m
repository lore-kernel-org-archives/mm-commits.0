From: akpm@linux-foundation.org
Subject: - documentation-prune-redundant-submitchecklist-items.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:25 -0500
Message-ID: <200802150225.m1F2PinL015183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753577AbYBOCZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:25:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Documentation: prune redundant SubmitChecklist items
has been removed from the -mm tree.  Its filename was
     documentation-prune-redundant-submitchecklist-items.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: prune redundant SubmitChecklist items
From: J. Bruce Fields <bfields@citi.umich.edu>

Kernel style is mentioned twice, and the git apply trick is a bit redundant
given the checkpatch.pl recommendation (which also checks for bad
whitespace).

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN Documentation/SubmitChecklist~documentation-prune-redundant-submitchecklist-items Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~documentation-prune-redundant-submitchecklist-items
+++ a/Documentation/SubmitChecklist
@@ -20,7 +20,11 @@ kernel patches.
 4: ppc64 is a good architecture for cross-compilation checking because it
    tends to use `unsigned long' for 64-bit quantities.
 
-5: Matches kernel coding style(!)
+5: Check your patch for general style as detailed in
+   Documentation/CodingStyle.  Check for trivial violations with the
+   patch style checker prior to submission (scripts/checkpatch.pl).
+   You should be able to justify all violations that remain in
+   your patch.
 
 6: Any new or modified CONFIG options don't muck up the config menu.
 
@@ -79,13 +83,3 @@ kernel patches.
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
     changes in the VM, VFS, and other subsystems.
-
-24: Avoid whitespace damage such as indenting with spaces or whitespace
-    at the end of lines.  You can test this by feeding the patch to
-    "git apply --check --whitespace=error-all"
-
-25: Check your patch for general style as detailed in
-    Documentation/CodingStyle.  Check for trivial violations with the
-    patch style checker prior to submission (scripts/checkpatch.pl).
-    You should be able to justify all violations that remain in
-    your patch.
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
use-struct-path-in-struct-svc_export.patch
git-nfsd.patch
reiser4.patch
