From: akpm@linux-foundation.org
Subject: + kernel-res_counter-remove-the-unused-api-fix-2.patch added to
 -mm tree
Date: Thu, 16 Oct 2014 12:32:05 -0700
Message-ID: <54401d35./naOx45FAWDe5Nuv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJPTcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 15:32:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-res_counter-remove-the-unused-api-fix-2
has been added to the -mm tree.  Its filename is
     kernel-res_counter-remove-the-unused-api-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-res_counter-remove-the-unused-api-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-res_counter-remove-the-unused-api-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: kernel-res_counter-remove-the-unused-api-fix-2

ditch the last remainings of res_counter

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroups/memory.txt~kernel-res_counter-remove-the-unused-api-fix-2 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~kernel-res_counter-remove-the-unused-api-fix-2
+++ a/Documentation/cgroups/memory.txt
@@ -116,16 +116,16 @@ The memory controller is the first contr
 
 2.1. Design
 
-The core of the design is a counter called the res_counter. The res_counter
-tracks the current memory usage and limit of the group of processes associated
-with the controller. Each cgroup has a memory controller specific data
-structure (mem_cgroup) associated with it.
+The core of the design is a counter called the page_counter. The
+page_counter tracks the current memory usage and limit of the group of
+processes associated with the controller. Each cgroup has a memory controller
+specific data structure (mem_cgroup) associated with it.
 
 2.2. Accounting
 
 		+--------------------+
-		|  mem_cgroup     |
-		|  (res_counter)     |
+		|  mem_cgroup        |
+		|  (page_counter)    |
 		+--------------------+
 		 /            ^      \
 		/             |       \
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
freezer-check-oom-kill-while-being-frozen.patch
freezer-remove-obsolete-comments-in-__thaw_task.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch

