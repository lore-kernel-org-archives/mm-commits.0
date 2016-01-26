From: akpm@linux-foundation.org
Subject: + documentation-cgroup-v2-add-memorystat-sock-description.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 13:31:08 -0800
Message-ID: <56a7e59c.b6M9lDmf90G3cp3k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbcAZVbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:31:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: cgroup-v2: add memory.stat::sock description
has been added to the -mm tree.  Its filename is
     documentation-cgroup-v2-add-memorystat-sock-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-cgroup-v2-add-memorystat-sock-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-cgroup-v2-add-memorystat-sock-description.patch

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

proc-revert-proc-pid-maps-annotation.patch
mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
documentation-cgroup-v2-add-memorystat-sock-description.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

