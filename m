From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-typos-in-memcg_testtxt.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:14 -0400
Message-ID: <201003150700.o2F70low016658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247Ab0COHAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix typos in memcg_test.txt
has been removed from the -mm tree.  Its filename was
     memcg-fix-typos-in-memcg_testtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix typos in memcg_test.txt
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memcg_test.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memcg_test.txt~memcg-fix-typos-in-memcg_testtxt Documentation/cgroups/memcg_test.txt
--- a/Documentation/cgroups/memcg_test.txt~memcg-fix-typos-in-memcg_testtxt
+++ a/Documentation/cgroups/memcg_test.txt
@@ -337,7 +337,7 @@ Under below explanation, we assume CONFI
 	race and lock dependency with other cgroup subsystems.
 
 	example)
-	# mount -t cgroup none /cgroup -t cpuset,memory,cpu,devices
+	# mount -t cgroup none /cgroup -o cpuset,memory,cpu,devices
 
 	and do task move, mkdir, rmdir etc...under this.
 
@@ -348,7 +348,7 @@ Under below explanation, we assume CONFI
 
 	For example, test like following is good.
 	(Shell-A)
-	# mount -t cgroup none /cgroup -t memory
+	# mount -t cgroup none /cgroup -o memory
 	# mkdir /cgroup/test
 	# echo 40M > /cgroup/test/memory.limit_in_bytes
 	# echo 0 > /cgroup/test/tasks
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

