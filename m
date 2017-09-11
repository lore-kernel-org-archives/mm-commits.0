From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-typo-in-comment.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:42:46 -0700
Message-ID: <20170911194246.-AfCtWuvt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50310 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdIKTmr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix typo in comment
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


