From: akpm@linux-foundation.org
Subject: [patch 093/126] checkpatch: fix typo in comment
Date: Fri, 08 Sep 2017 16:16:04 -0700
Message-ID: <20170908231604.MKT3glcss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53250 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
