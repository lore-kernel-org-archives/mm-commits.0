From: akpm@linux-foundation.org
Subject: - checkpatch-handle-return-types-of-pointers-to-functions.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:42 -0700
Message-ID: <200807242326.m6ONQgct011007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884AbYGXX0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: handle return types of pointers to functions
has been removed from the -mm tree.  Its filename was
     checkpatch-handle-return-types-of-pointers-to-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: handle return types of pointers to functions
From: Andy Whitcroft <apw@shadowen.org>

Make sure we correctly mark the return type of the pointer to a function
declaration.

    const void *(*sb_tag)(struct sysfs_tag_info *info);

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-handle-return-types-of-pointers-to-functions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-return-types-of-pointers-to-functions
+++ a/scripts/checkpatch.pl
@@ -715,7 +715,7 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\))/) {
+		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\()/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

