From: akpm@linux-foundation.org
Subject: - include-linux-bcdh-remove-comments.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:38:02 -0700
Message-ID: <200810202038.m9KKc2KW011776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753754AbYJTUqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/bcd.h: remove comments
has been removed from the -mm tree.  Its filename was
     include-linux-bcdh-remove-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/bcd.h: remove comments
From: Adrian Bunk <bunk@kernel.org>

- the macros are gone
- there's no more code in this file,
  LGPL + GPL = GPL,
  and the code that was moved to lib/bcd.c is anyway trivial

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bcd.h |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN include/linux/bcd.h~include-linux-bcdh-remove-comments include/linux/bcd.h
--- a/include/linux/bcd.h~include-linux-bcdh-remove-comments
+++ a/include/linux/bcd.h
@@ -1,12 +1,3 @@
-/* Permission is hereby granted to copy, modify and redistribute this code
- * in terms of the GNU Library General Public License, Version 2 or later,
- * at your option.
- */
-
-/* macros to translate to/from binary and binary-coded decimal (frequently
- * found in RTC chips).
- */
