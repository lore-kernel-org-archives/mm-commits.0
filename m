From: akpm@linux-foundation.org
Subject: [merged] memcg-kconfig-info-update.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:30 -0700
Message-ID: <51db1266.r0xa58oWFm9DtYaA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3GHT0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, dserrg@gmail.com

Subject: [merged] memcg-kconfig-info-update.patch removed from -mm tree
To: dserrg@gmail.com,hannes@cmpxchg.org,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:30 -0700


The patch titled
     Subject: memcg: Kconfig info update
has been removed from the -mm tree.  Its filename was
     memcg-kconfig-info-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Dyasly <dserrg@gmail.com>
Subject: memcg: Kconfig info update

Now there are only 2 members in struct page_cgroup.  Update config MEMCG
description accordingly.

Signed-off-by: Sergey Dyasly <dserrg@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~memcg-kconfig-info-update init/Kconfig
--- a/init/Kconfig~memcg-kconfig-info-update
+++ a/init/Kconfig
@@ -899,7 +899,7 @@ config MEMCG
 
 	  Note that setting this option increases fixed memory overhead
 	  associated with each page of memory in the system. By this,
-	  20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
+	  8(16)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
 	  usage tracking struct at boot. Total amount of this is printed out
 	  at boot.
 
_

Patches currently in -mm which might be from dserrg@gmail.com are

origin.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch

