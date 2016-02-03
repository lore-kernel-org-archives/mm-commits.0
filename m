From: akpm@linux-foundation.org
Subject: [merged]
 documentation-cgroup-v2-add-memorystat-sock-description.patch removed from
 -mm tree
Date: Wed, 03 Feb 2016 13:53:19 -0800
Message-ID: <56b276cf.pMU3u+T1vt+URWbJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: cgroup-v2: add memory.stat::sock description
has been removed from the -mm tree.  Its filename was
     documentation-cgroup-v2-add-memorystat-sock-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Documentation: cgroup-v2: add memory.stat::sock description

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/cgroup-v2.txt~documentation-cgroup-v2-add-memorystat-sock-description Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~documentation-cgroup-v2-add-memorystat-sock-description
+++ a/Documentation/cgroup-v2.txt
@@ -843,6 +843,10 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used to cache filesystem data,
 		including tmpfs and shared memory.
 
+	  sock
+
+		Amount of memory used in network transmission buffers
+
 	  file_mapped
 
 		Amount of cached filesystem data mapped with mmap()
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
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

