From: akpm@linux-foundation.org
Subject: [merged]
 memcg-document-cgroup-dirty-writeback-memory-statistics.patch removed from
 -mm tree
Date: Fri, 13 Sep 2013 13:02:48 -0700
Message-ID: <52336f68.ouFVEUnbAg69FlV0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, fengguang.wu@intel.com, handai.szj@taobao.com

Subject: [merged] memcg-document-cgroup-dirty-writeback-memory-statistics.patch removed from -mm tree
To: handai.szj@taobao.com,fengguang.wu@intel.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:48 -0700


The patch titled
     Subject: memcg: document cgroup dirty/writeback memory statistics
has been removed from the -mm tree.  Its filename was
     memcg-document-cgroup-dirty-writeback-memory-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: document cgroup dirty/writeback memory statistics

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-writeback-memory-statistics Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-writeback-memory-statistics
+++ a/Documentation/cgroups/memory.txt
@@ -490,6 +490,8 @@ pgpgin		- # of charging events to the me
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
+writeback	- # of bytes of file/anon cache that are queued for syncing to
+		disk.
 inactive_anon	- # of bytes of anonymous and swap cache memory on inactive
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
_

Patches currently in -mm which might be from handai.szj@taobao.com are

origin.patch

