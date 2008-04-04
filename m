From: akpm@linux-foundation.org
Subject: - doc-fix-typo-in-submittingpatches.patch removed from -mm tree
Date: Fri, 04 Apr 2008 11:59:56 -0700
Message-ID: <200804041859.m34IxuYR004139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756739AbYDDTA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, meyering@redhat.com, mm-commits@vger.kernel.org


The patch titled
     doc: fix typo in SubmittingPatches
has been removed from the -mm tree.  Its filename was
     doc-fix-typo-in-submittingpatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: fix typo in SubmittingPatches
From: Jim Meyering <jim@meyering.net>

Signed-off-by: Jim Meyering <meyering@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~doc-fix-typo-in-submittingpatches Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~doc-fix-typo-in-submittingpatches
+++ a/Documentation/SubmittingPatches
@@ -512,7 +512,7 @@ They provide type safety, have no length
 limitations, and under gcc they are as cheap as macros.
 
 Macros should only be used for cases where a static inline is clearly
-suboptimal [there a few, isolated cases of this in fast paths],
+suboptimal [there are a few, isolated cases of this in fast paths],
 or where it is impossible to use a static inline function [such as
 string-izing].
 
_

Patches currently in -mm which might be from jim@meyering.net are

origin.patch
git-v9fs.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch

