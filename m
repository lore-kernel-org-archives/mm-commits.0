From: akpm@linux-foundation.org
Subject: - checkpatch-accept-any-sized-le-be-type.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:04 -0700
Message-ID: <200810182314.m9INE4gd028320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499AbYJRXOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: accept any sized le/be type
has been removed from the -mm tree.  Its filename was
     checkpatch-accept-any-sized-le-be-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: accept any sized le/be type
From: Andy Whitcroft <apw@shadowen.org>

We are likely going to have 24 bit types.  Expand the type matcher to
match any size.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-accept-any-sized-le-be-type scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-accept-any-sized-le-be-type
+++ a/scripts/checkpatch.pl
@@ -159,7 +159,7 @@ our @typeList = (
 	qr{float},
 	qr{double},
 	qr{bool},
-	qr{(?:__)?(?:u|s|be|le)(?:8|16|32|64)},
+	qr{(?:__)?(?:u|s|be|le)(?:\d|\d\d)},
 	qr{struct\s+$Ident},
 	qr{union\s+$Ident},
 	qr{enum\s+$Ident},
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

