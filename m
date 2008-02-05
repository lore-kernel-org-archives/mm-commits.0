From: akpm@linux-foundation.org
Subject: - radix_treeh-trivial-comment-correction.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:03 -0800
Message-ID: <200802050253.m152riZj031528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbYBECxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:53:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     radix_tree.h: trivial comment correction
has been removed from the -mm tree.  Its filename was
     radix_treeh-trivial-comment-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
