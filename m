From: akpm@linux-foundation.org
Subject: - lockstat-documentation-update.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:08 -0700
Message-ID: <200809130746.m8D7k8pF026828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378AbYIMHqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lockstat: documentation update
has been removed from the -mm tree.  Its filename was
     lockstat-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

