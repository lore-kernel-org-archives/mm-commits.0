From: akpm@linux-foundation.org
Subject: [merged]
 removing-textsearch_put-reference-from-the-comments.patch removed from -mm
 tree
Date: Tue, 14 Oct 2014 11:19:27 -0700
Message-ID: <543d692f.fmiKwtf0KoDez+lK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaJNSTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rapphil@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/textsearch.c: remove textsearch_put reference from comments
has been removed from the -mm tree.  Its filename was
     removing-textsearch_put-reference-from-the-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Raphael Silva <rapphil@gmail.com>
Subject: lib/textsearch.c: remove textsearch_put reference from comments

There is no textsearch_put().  Remove it from the comments to avoid
misunderstanding.  Textsearch prepare no longer needs textsearch_put().

Signed-off-by: Raphael Silva <rapphil@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/textsearch.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/textsearch.c~removing-textsearch_put-reference-from-the-comments lib/textsearch.c
--- a/lib/textsearch.c~removing-textsearch_put-reference-from-the-comments
+++ a/lib/textsearch.c
@@ -249,9 +249,7 @@ EXPORT_SYMBOL(textsearch_find_continuous
  * @flags: search flags
  *
  * Looks up the search algorithm module and creates a new textsearch
- * configuration for the specified pattern. Upon completion all
- * necessary refcnts are held and the configuration must be put back
- * using textsearch_put() after usage.
+ * configuration for the specified pattern.
  *
  * Note: The format of the pattern may not be compatible between
  *       the various search algorithms.
_

Patches currently in -mm which might be from rapphil@gmail.com are

origin.patch

