From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch removed from
 -mm tree
Date: Thu, 17 Mar 2016 13:56:55 -0700
Message-ID: <56eb1a17.kXZy49cBiyz9Ksrt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030437AbcCQU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-scale-kswapd-watermarks-in-proportion-to-memory-v3
has been removed from the -mm tree.  Its filename was
     mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch

This patch was dropped because it was folded into mm-scale-kswapd-watermarks-in-proportion-to-memory.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-scale-kswapd-watermarks-in-proportion-to-memory-v3

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-scale-kswapd-watermarks-in-proportion-to-memory-v3 Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-scale-kswapd-watermarks-in-proportion-to-memory-v3
+++ a/Documentation/sysctl/vm.txt
@@ -812,7 +812,7 @@ amount of memory left in a node/system b
 how much memory needs to be free before kswapd goes back to sleep.
 
 The unit is in fractions of 10,000. The default value of 10 means the
-distances between watermarks are 0.001% of the available memory in the
+distances between watermarks are 0.1% of the available memory in the
 node/system. The maximum value is 1000, or 10% of memory.
 
 A high rate of threads entering direct reclaim (allocstall) or kswapd
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

