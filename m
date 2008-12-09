From: akpm@linux-foundation.org
Subject: + checkpatch-update-maintainers-entry.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:26 -0800
Message-ID: <200812090004.mB904Quf031040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbYLIAFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, jschopp@austin.ibm.com, rdunlap@xenotime.net


The patch titled
     checkpatch: update MAINTAINERS entry
has been added to the -mm tree.  Its filename is
     checkpatch-update-maintainers-entry.patch

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
Subject: checkpatch: update MAINTAINERS entry
From: Andy Whitcroft <apw@shadowen.org>

Update my email address to my new work address.  Also, as per our recent
email conversation remove Randy and Joel from the maintainers list. 
Finally add LKML so that emails are recorded somewhere.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~checkpatch-update-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~checkpatch-update-maintainers-entry
+++ a/MAINTAINERS
@@ -1092,11 +1092,8 @@ S:	Maintained
 
 CHECKPATCH
 P:	Andy Whitcroft
-M:	apw@shadowen.org
-P:	Randy Dunlap
-M:	rdunlap@xenotime.net
-P:	Joel Schopp
-M:	jschopp@austin.ibm.com
+M:	apw@canonical.com
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 
 CISCO 10G ETHERNET DRIVER
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
checkpatch-update-maintainers-entry.patch

