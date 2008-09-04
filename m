From: akpm@linux-foundation.org
Subject: + lockstat-documentation-update.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:11:50 -0700
Message-ID: <200809042111.m84LBoX4031341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbYIDVM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl


The patch titled
     lockstat: documentation update
has been added to the -mm tree.  Its filename is
     lockstat-documentation-update.patch

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
Subject: lockstat: documentation update
From: Peter Zijlstra <peterz@infradead.org>

Christoph noted that the documentation doesn't tell in what units the
lockstat times are reported.  Amend this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lockstat.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/lockstat.txt~lockstat-documentation-update Documentation/lockstat.txt
--- a/Documentation/lockstat.txt~lockstat-documentation-update
+++ a/Documentation/lockstat.txt
@@ -100,6 +100,7 @@ The first lock (05-10) is a read/write l
 short separator. The contention points don't match the column descriptors,
 they have two: contentions and [<IP>] symbol.
 
+The integer part of the time values is in us.
 
 View the top contending locks:
 
_

Patches currently in -mm which might be from peterz@infradead.org are

linux-next.patch
lockstat-documentation-update.patch

