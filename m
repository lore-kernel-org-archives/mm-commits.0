From: akpm@linux-foundation.org
Subject: + fix-typos-in-documentation-unaligned-memory-accesstxt.patch added to -mm tree
Date: Mon, 31 Mar 2008 16:25:29 -0700
Message-ID: <200803312325.m2VNPULh031313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbYCaX0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 19:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitri.vorobiev@gmail.com


The patch titled
     Fix typos in Documentation/unaligned-memory-access.txt
has been added to the -mm tree.  Its filename is
     fix-typos-in-documentation-unaligned-memory-accesstxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-typos-in-documentation-unaligned-memory-accesstxt.patch

