From: akpm@linux-foundation.org
Subject: [merged] cgroups-documentation-fix-wrong-cgroupfs-paths.patch
 removed from -mm tree
Date: Thu, 04 Dec 2014 14:37:10 -0800
Message-ID: <5480e216.q8jL7wA/bYXgkXAM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbaLDWhL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Dec 2014 17:37:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sj38.park@gmail.com, corbet@lwn.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: documentation: fix wrong cgroupfs paths
has been removed from the -mm tree.  Its filename was
     cgroups-documentation-fix-wrong-cgroupfs-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: cgroups: documentation: fix wrong cgroupfs paths

Few paths used as example to describe cgroupfs usage have been wrong from
f6e07d38078e ("Documentation: update cgroupfs mount point") by mistake. 
This patch fixes those trivial wrong paths.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-documentation-fix-wrong-cgroupfs-paths Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-documentation-fix-wrong-cgroupfs-paths
+++ a/Documentation/cgroups/cgroups.txt
@@ -312,10 +312,10 @@ the "cpuset" cgroup subsystem, the steps
  2) mkdir /sys/fs/cgroup/cpuset
  3) mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
  4) Create the new cgroup by doing mkdir's and write's (or echo's) in
-    the /sys/fs/cgroup virtual file system.
+    the /sys/fs/cgroup/cpuset virtual file system.
  5) Start a task that will be the "founding father" of the new job.
  6) Attach that task to the new cgroup by writing its PID to the
-    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
+    /sys/fs/cgroup/cpuset tasks file for that cgroup.
  7) fork, exec or clone the job tasks from this founding father task.
 
 For example, the following sequence of commands will setup a cgroup
_

Patches currently in -mm which might be from sj38.park@gmail.com are

linux-next.patch
cgroups-documentation-fix-trivial-typos-and-wrong-paragraph-numberings.patch

