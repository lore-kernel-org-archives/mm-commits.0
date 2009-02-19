From: akpm@linux-foundation.org
Subject: [merged] cgroups-update-documentation-about-css_set-hash-table.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:24 -0800
Message-ID: <200902191916.n1JJGOdp016247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbZBSTQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: update documentation about css_set hash table
has been removed from the -mm tree.  Its filename was
     cgroups-update-documentation-about-css_set-hash-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: update documentation about css_set hash table
From: Li Zefan <lizf@cn.fujitsu.com>

The css_set hash table was introduced in 2.6.26, so update the
documentation accordingly.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-update-documentation-about-css_set-hash-table Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-update-documentation-about-css_set-hash-table
+++ a/Documentation/cgroups/cgroups.txt
@@ -252,10 +252,8 @@ cgroup file system directories.
 When a task is moved from one cgroup to another, it gets a new
 css_set pointer - if there's an already existing css_set with the
 desired collection of cgroups then that group is reused, else a new
-css_set is allocated. Note that the current implementation uses a
-linear search to locate an appropriate existing css_set, so isn't
-very efficient. A future version will use a hash table for better
-performance.
+css_set is allocated. The appropriate existing css_set is located by
+looking into a hash table.
 
 To allow access from a cgroup to the css_sets (and hence tasks)
 that comprise it, a set of cg_cgroup_link objects form a lattice;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

