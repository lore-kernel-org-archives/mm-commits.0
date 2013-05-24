From: akpm@linux-foundation.org
Subject: + memcg-update-todo-list-in-documentation.patch added to -mm tree
Date: Fri, 24 May 2013 14:38:08 -0700
Message-ID: <519fddc0.G4nFTchEEDH+1y4+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3EXViJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 17:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, lizefan@huawei.com

Subject: + memcg-update-todo-list-in-documentation.patch added to -mm tree
To: lizefan@huawei.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rob@landley.net
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 14:38:08 -0700


The patch titled
     Subject: memcg: update TODO list in Documentation
has been added to the -mm tree.  Its filename is
     memcg-update-todo-list-in-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
ocfs2-unlock-rw-lock-if-inode-lock-failed.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
memcg-update-todo-list-in-documentation.patch

