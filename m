From: akpm@linux-foundation.org
Subject: + removing-textsearch_put-reference-from-the-comments.patch added to -mm tree
Date: Wed, 10 Sep 2014 16:14:56 -0700
Message-ID: <5410db70.R+cThHM7sQNVS9kM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaIJXO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 19:14:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rapphil@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/textsearch.c: remove textsearch_put reference from comments
has been added to the -mm tree.  Its filename is
     removing-textsearch_put-reference-from-the-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/removing-textsearch_put-reference-from-the-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/removing-textsearch_put-reference-from-the-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

removing-textsearch_put-reference-from-the-comments.patch

