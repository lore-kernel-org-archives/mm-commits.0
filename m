From: akpm@linux-foundation.org
Subject: [merged] memcg-update-todo-list-in-documentation.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:25:32 -0700
Message-ID: <51db122c.8qb059f0S7UJWWsD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3GHTZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, lizefan@huawei.com

Subject: [merged] memcg-update-todo-list-in-documentation.patch removed from -mm tree
To: lizefan@huawei.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:32 -0700


The patch titled
     Subject: memcg: update TODO list in Documentation
has been removed from the -mm tree.  Its filename was
     memcg-update-todo-list-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: update TODO list in Documentation

hugetlb cgroup has already been implemented.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rob Landley <rob@landley.net>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-update-todo-list-in-documentation Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-update-todo-list-in-documentation
+++ a/Documentation/cgroups/memory.txt
@@ -834,10 +834,9 @@ Test:
 
 12. TODO
 
-1. Add support for accounting huge pages (as a separate controller)
-2. Make per-cgroup scanner reclaim not-shared pages first
-3. Teach controller to account for shared-pages
-4. Start reclamation in the background when the limit is
+1. Make per-cgroup scanner reclaim not-shared pages first
+2. Teach controller to account for shared-pages
+3. Start reclamation in the background when the limit is
    not yet hit but the usage is getting closer
 
 Summary
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch
revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-kmem-fix-reference-count-handling-on-the-error-path.patch
memcg-use-css_get-in-sock_update_memcg.patch
memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
memcg-use-css_get-put-for-swap-memcg.patch
memcg-dont-need-to-get-a-reference-to-the-parent.patch
memcg-kill-memcg-refcnt.patch
memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch

