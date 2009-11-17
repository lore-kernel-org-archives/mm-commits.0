From: akpm@linux-foundation.org
Subject: [merged] page-types-trivial-typo-fixes.patch removed from -mm tree
Date: Tue, 17 Nov 2009 13:13:30 -0800
Message-ID: <200911172113.nAHLDUnD009526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbZKQVN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Nov 2009 16:13:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tt.rantala@gmail.com, fengguang.wu@intel.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     page-types: trivial typo fixes
has been removed from the -mm tree.  Its filename was
     page-types-trivial-typo-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

