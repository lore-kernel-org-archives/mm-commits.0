From: akpm@linux-foundation.org
Subject: + fix-typo-in-documentation-submittingpatches.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:09:19 -0700
Message-ID: <200709100809.l8A89J38014777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbXIJIJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@finow14.de


The patch titled
     fix typo in Documentation/SubmittingPatches
has been added to the -mm tree.  Its filename is
     fix-typo-in-documentation-submittingpatches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix typo in Documentation/SubmittingPatches
From: Andre Haupt <andre@finow14.de>

Signed-off-by: Andre Haupt <andre@finow14.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

fix-typo-in-documentation-submittingpatches.patch
git-cifs.patch
fix-a-trivial-typo-in-scripts-checkstackpl.patch
