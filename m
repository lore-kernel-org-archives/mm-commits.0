From: akpm@linux-foundation.org
Subject: - cgroups-fix-documentation.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:09 -0700
Message-ID: <200805132134.m4DLY9vE000896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760053AbYEMVek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhaval@linux.vnet.ibm.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, skumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix documentation
has been removed from the -mm tree.  Its filename was
     cgroups-fix-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix documentation
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Correct the cgroups documentation to reflect the correct file names.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups.txt~cgroups-fix-documentation Documentation/cgroups.txt
--- a/Documentation/cgroups.txt~cgroups-fix-documentation
+++ a/Documentation/cgroups.txt
@@ -310,8 +310,8 @@ and then start a subshell 'sh' in that c
   cd /dev/cgroup
   mkdir Charlie
   cd Charlie
-  /bin/echo 2-3 > cpus
-  /bin/echo 1 > mems
+  /bin/echo 2-3 > cpuset.cpus
+  /bin/echo 1 > cpuset.mems
   /bin/echo $$ > tasks
   sh
   # The subshell 'sh' is now running in cgroup Charlie
_

Patches currently in -mm which might be from dhaval@linux.vnet.ibm.com are

origin.patch

