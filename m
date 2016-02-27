From: akpm@linux-foundation.org
Subject: + mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
 added to -mm tree
Date: Fri, 26 Feb 2016 16:43:15 -0800
Message-ID: <56d0f123.i5+47qI48VC6xQFe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbcB0AnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 19:43:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-scale-kswapd-watermarks-in-proportion-to-memory-v3
has been added to the -mm tree.  Its filename is
     mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-migrate-consolidate-mem_cgroup_migrate-calls.patch
mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch

