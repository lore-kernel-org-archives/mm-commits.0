From: akpm@linux-foundation.org
Subject: + checkpatch-fix-typo-in-comment.patch added to -mm tree
Date: Tue, 05 Sep 2017 16:41:20 -0700
Message-ID: <59af3620.ejeWHuo8q4HfaN3i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753652AbdIEXlV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix typo in comment
has been added to the -mm tree.  Its filename is
     checkpatch-fix-typo-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-typo-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: checkpatch: fix typo in comment

Link: http://lkml.kernel.org/r/20170902175249.15bb77f2@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-typo-in-comment scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-typo-in-comment
+++ a/scripts/checkpatch.pl
@@ -2875,7 +2875,7 @@ sub process {
 #	#defines that are a single string
 #
 # There are 3 different line length message types:
-# LONG_LINE_COMMENT	a comment starts before but extends beyond $max_linelength
+# LONG_LINE_COMMENT	a comment starts before but extends beyond $max_line_length
 # LONG_LINE_STRING	a string starts before but extends beyond $max_line_length
 # LONG_LINE		all other lines longer than $max_line_length
 #
_

Patches currently in -mm which might be from jdelvare@suse.de are

checkpatch-fix-typo-in-comment.patch
checkpatch-rename-variables-to-avoid-confusion.patch
checkpatch-add-6-missing-types-to-list-types.patch

