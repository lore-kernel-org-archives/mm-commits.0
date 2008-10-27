From: akpm@linux-foundation.org
Subject: + checkpatch-__weak-is-an-official-attribute.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:32:11 -0700
Message-ID: <200810272132.m9RLWB85005150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbYJ0VcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: __weak is an official attribute
has been added to the -mm tree.  Its filename is
     checkpatch-__weak-is-an-official-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: __weak is an official attribute
From: Andy Whitcroft <apw@shadowen.org>

Add __weak as an official attribute.  This tends to be used in a location
where the automated attribute detector misses it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-__weak-is-an-official-attribute scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-__weak-is-an-official-attribute
+++ a/scripts/checkpatch.pl
@@ -116,7 +116,8 @@ our $Attribute	= qr{
 			__(?:mem|cpu|dev|)(?:initdata|init)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
-			____cacheline_internodealigned_in_smp
+			____cacheline_internodealigned_in_smp|
+			__weak
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
_

Patches currently in -mm which might be from apw@shadowen.org are

checkpatch-add-checks-for-in_atomic.patch
checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch
checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch
checkpatch-structure-member-assignments-are-not-complex.patch
checkpatch-__weak-is-an-official-attribute.patch
checkpatch-detect-multiple-bitfield-declarations.patch
checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch
checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch
checkpatch-version-025.patch

