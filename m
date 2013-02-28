From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-camelcase-test-for-page.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:17 -0800
Message-ID: <20130228201020.7A4E031C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:56647 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3B1UKV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:21 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so244412ghb.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve CamelCase test for Page
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-camelcase-test-for-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve CamelCase test for Page

Add the ClearPage/SetPage/TestClearPage/TestSetPage variants to the not
reported Page CamelCase variables.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-camelcase-test-for-page scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-camelcase-test-for-page
+++ a/scripts/checkpatch.pl
@@ -2930,7 +2930,7 @@ sub process {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
-			    $var !~ /^Page[A-Z]/ &&
+			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

