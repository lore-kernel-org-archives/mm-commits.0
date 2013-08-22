From: akpm@linux-foundation.org
Subject: + memcg-document-cgroup-dirty-writeback-memory-statistics.patch
 added to -mm tree
Date: Thu, 22 Aug 2013 15:43:35 -0700
Message-ID: <52169417.wMqe99Gpg4/Xb6jm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3HVWng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 18:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, fengguang.wu@intel.com, handai.szj@taobao.com

Subject: + memcg-document-cgroup-dirty-writeback-memory-statistics.patch added to -mm tree
To: handai.szj@taobao.com,fengguang.wu@intel.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 15:43:35 -0700


The patch titled
     Subject: memcg: document cgroup dirty/writeback memory statistics
has been added to the -mm tree.  Its filename is
     memcg-document-cgroup-dirty-writeback-memory-statistics.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-document-cgroup-dirty-writeback-memory-statistics.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-document-cgroup-dirty-writeback-memory-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch

