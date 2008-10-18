From: akpm@linux-foundation.org
Subject: - checkpatch-allow-for-comments-either-side-of-a-brace-on-case.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:18 -0700
Message-ID: <200810182314.m9INEI1V028379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbYJRXO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: allow for comments either side of a brace on case
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-for-comments-either-side-of-a-brace-on-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: allow for comments either side of a brace on case
From: Andy Whitcroft <apw@shadowen.org>

When specifying case we may have comments and/or braces at the end without
actually having a 'statement'.  Allow for these to occur in any order.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-for-comments-either-side-of-a-brace-on-case scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-for-comments-either-side-of-a-brace-on-case
+++ a/scripts/checkpatch.pl
@@ -2043,7 +2043,7 @@ sub process {
 # case and default should not have general statements after them
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
 		    $line !~ /\G(?:
-			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
+			(?:\s*$;*)(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
 			\s*return\s+
 		    )/xg)
 		{
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

