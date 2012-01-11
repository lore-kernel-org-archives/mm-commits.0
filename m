From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-complex-macros-handling-of-square-brackets.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:33 -0800
Message-ID: <20120111213133.98324100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:47781 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:34 -0500
Received: by yhpp56 with SMTP id p56so154250yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix complex macros handling of square brackets
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-complex-macros-handling-of-square-brackets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: fix complex macros handling of square brackets

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-complex-macros-handling-of-square-brackets scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-complex-macros-handling-of-square-brackets
+++ a/scripts/checkpatch.pl
@@ -2815,7 +2815,7 @@ sub process {
 			# Flatten any parentheses and braces
 			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
 			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
-			       $dstat =~ s/\[[^\{\}]*\]/1/)
+			       $dstat =~ s/\[[^\[\]]*\]/1/)
 			{
 			}
 
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

