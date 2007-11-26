From: akpm@linux-foundation.org
Subject: + radix_treeh-trivial-comment-correction.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:01:02 -0800
Message-ID: <200711262301.lAQN13jV027515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbXKZXBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:01:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lnxninja@linux.vnet.ibm.com, npiggin@suse.de


The patch titled
     radix_tree.h: trivial comment correction
has been added to the -mm tree.  Its filename is
     radix_treeh-trivial-comment-correction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: radix_tree.h: trivial comment correction
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>

There is an unmatched parenthesis in the locking commentary of radix_tree.h
which is trivially fixed by the patch below.

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/radix-tree.h~radix_treeh-trivial-comment-correction include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix_treeh-trivial-comment-correction
+++ a/include/linux/radix-tree.h
@@ -91,7 +91,7 @@ do {									\
  *
  * For API usage, in general,
  * - any function _modifying_ the tree or tags (inserting or deleting
- *   items, setting or clearing tags must exclude other modifications, and
+ *   items, setting or clearing tags) must exclude other modifications, and
  *   exclude any functions reading the tree.
  * - any function _reading_ the tree or tags (looking up items or tags,
  *   gang lookups) must exclude modifications to the tree, but may occur
_

Patches currently in -mm which might be from lnxninja@linux.vnet.ibm.com are

radix_treeh-trivial-comment-correction.patch
