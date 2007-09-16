From: akpm@linux-foundation.org
Subject: - fix-typo-in-documentation-submittingpatches.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:55 -0700
Message-ID: <200709160925.l8G9PtOE009142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbXIPJZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@finow14.de, mm-commits@vger.kernel.org


The patch titled
     fix typo in Documentation/SubmittingPatches
has been removed from the -mm tree.  Its filename was
     fix-typo-in-documentation-submittingpatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix typo in Documentation/SubmittingPatches
From: Andre Haupt <andre@finow14.de>

Signed-off-by: Andre Haupt <andre@finow14.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~fix-typo-in-documentation-submittingpatches Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~fix-typo-in-documentation-submittingpatches
+++ a/Documentation/SubmittingPatches
@@ -126,7 +126,7 @@ the reviewers time and will get your pat
 without even being read.
 
 At a minimum you should check your patches with the patch style
-checker prior to submission (scripts/patchcheck.pl).  You should
+checker prior to submission (scripts/checkpatch.pl).  You should
 be able to justify all violations that remain in your patch.
 
 
_

Patches currently in -mm which might be from andre@finow14.de are

origin.patch
git-cifs.patch
fix-a-trivial-typo-in-scripts-checkstackpl.patch
