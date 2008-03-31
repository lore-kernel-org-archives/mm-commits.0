From: akpm@linux-foundation.org
Subject: + doc-fix-typo-in-submittingpatches.patch added to -mm tree
Date: Mon, 31 Mar 2008 16:01:58 -0700
Message-ID: <200803312301.m2VN1wug030412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbYCaXCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 19:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim@meyering.net, meyering@redhat.com


The patch titled
     doc: fix typo in SubmittingPatches
has been added to the -mm tree.  Its filename is
     doc-fix-typo-in-submittingpatches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

doc-fix-typo-in-submittingpatches.patch
git-v9fs.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch

