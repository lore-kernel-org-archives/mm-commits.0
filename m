From: akpm@linux-foundation.org
Subject: - fix-typos-in-documentation-unaligned-memory-accesstxt.patch removed from -mm tree
Date: Fri, 04 Apr 2008 11:59:54 -0700
Message-ID: <200804041859.m34Ixsn4004136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYDDS74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 14:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitri.vorobiev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix typos in Documentation/unaligned-memory-access.txt
has been removed from the -mm tree.  Its filename was
     fix-typos-in-documentation-unaligned-memory-accesstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix typos in Documentation/unaligned-memory-access.txt
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

This patch deletes a couple of superfluous word occurrences in the document
Documentation/unaligned-memory-access.txt.

Thanks to Sebastien Dugue for the remark about English usage.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/unaligned-memory-access.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/unaligned-memory-access.txt~fix-typos-in-documentation-unaligned-memory-accesstxt Documentation/unaligned-memory-access.txt
--- a/Documentation/unaligned-memory-access.txt~fix-typos-in-documentation-unaligned-memory-accesstxt
+++ a/Documentation/unaligned-memory-access.txt
@@ -57,7 +57,7 @@ here; a summary of the common scenarios 
    unaligned access to be corrected.
  - Some architectures are not capable of unaligned memory access, but will
    silently perform a different memory access to the one that was requested,
-   resulting a a subtle code bug that is hard to detect!
+   resulting in a subtle code bug that is hard to detect!
 
 It should be obvious from the above that if your code causes unaligned
 memory accesses to happen, your code will not work correctly on certain
@@ -209,7 +209,7 @@ memory and you wish to avoid unaligned a
 
 	u32 value = get_unaligned((u32 *) data);
 
-These macros work work for memory accesses of any length (not just 32 bits as
+These macros work for memory accesses of any length (not just 32 bits as
 in the examples above). Be aware that when compared to standard access of
 aligned memory, using these macros to access unaligned memory can be costly in
 terms of performance.
_

Patches currently in -mm which might be from dmitri.vorobiev@gmail.com are

origin.patch
git-mips.patch

