From: akpm@linux-foundation.org
Subject: - fix-typos-in-documentation-filesystems-seq_filetxt.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:04 -0700
Message-ID: <200804162255.m3GMt4am011082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbYDPXBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitri.vorobiev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix typos in Documentation/filesystems/seq_file.txt
has been removed from the -mm tree.  Its filename was
     fix-typos-in-documentation-filesystems-seq_filetxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix typos in Documentation/filesystems/seq_file.txt
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

A couple of typos crept into the newly added document about the seq_file
interface.  This patch corrects those typos and simultaneously deletes
unnecessary trailing spaces.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/seq_file.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/seq_file.txt~fix-typos-in-documentation-filesystems-seq_filetxt Documentation/filesystems/seq_file.txt
--- a/Documentation/filesystems/seq_file.txt~fix-typos-in-documentation-filesystems-seq_filetxt
+++ a/Documentation/filesystems/seq_file.txt
@@ -92,7 +92,7 @@ implementations; in most cases the start
 "past end of file" condition and return NULL if need be.
 
 For more complicated applications, the private field of the seq_file
-structure can be used. There is also a special value whch can be returned
+structure can be used. There is also a special value which can be returned
 by the start() function called SEQ_START_TOKEN; it can be used if you wish
 to instruct your show() function (described below) to print a header at the
 top of the output. SEQ_START_TOKEN should only be used if the offset is
@@ -146,7 +146,7 @@ the four functions we have just defined:
 This structure will be needed to tie our iterator to the /proc file in
 a little bit.
 
-It's worth noting that the interator value returned by start() and
+It's worth noting that the iterator value returned by start() and
 manipulated by the other functions is considered to be completely opaque by
 the seq_file code. It can thus be anything that is useful in stepping
 through the data to be output. Counters can be useful, but it could also be
@@ -262,7 +262,7 @@ routines useful:
 
 These helpers will interpret pos as a position within the list and iterate
 accordingly.  Your start() and next() functions need only invoke the
-seq_list_* helpers with a pointer to the appropriate list_head structure.  
+seq_list_* helpers with a pointer to the appropriate list_head structure.
 
 
 The extra-simple version
_

Patches currently in -mm which might be from dmitri.vorobiev@gmail.com are

origin.patch
git-mips.patch

