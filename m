From: akpm@linux-foundation.org
Subject: + page-types-trivial-typo-fixes.patch added to -mm tree
Date: Mon, 12 Oct 2009 14:49:40 -0700
Message-ID: <200910122149.n9CLnemw024823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933333AbZJLVvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 17:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tt.rantala@gmail.com, fengguang.wu@intel.com, rdunlap@xenotime.net


The patch titled
     page-types: trivial typo fixes
has been added to the -mm tree.  Its filename is
     page-types-trivial-typo-fixes.patch

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
Subject: page-types: trivial typo fixes
From: Tommi Rantala <tt.rantala@gmail.com>

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-trivial-typo-fixes Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-trivial-typo-fixes
+++ a/Documentation/vm/page-types.c
@@ -301,7 +301,7 @@ static char *page_flag_name(uint64_t fla
 		present = (flags >> i) & 1;
 		if (!page_flag_names[i]) {
 			if (present)
-				fatal("unkown flag bit %d\n", i);
+				fatal("unknown flag bit %d\n", i);
 			continue;
 		}
 		buf[j++] = present ? page_flag_names[i][0] : '_';
@@ -682,7 +682,7 @@ static void usage(void)
 #endif
 "            -l|--list                 Show page details in ranges\n"
 "            -L|--list-each            Show page details one by one\n"
-"            -N|--no-summary           Don't show summay info\n"
+"            -N|--no-summary           Don't show summary info\n"
 "            -X|--hwpoison             hwpoison pages\n"
 "            -x|--unpoison             unpoison pages\n"
 "            -h|--help                 Show this usage message\n"
_

Patches currently in -mm which might be from tt.rantala@gmail.com are

page-types-constify-read-only-arrays.patch
page-types-trivial-typo-fixes.patch

