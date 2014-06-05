From: akpm@linux-foundation.org
Subject: [merged] memcg-un-export-__memcg_kmem_get_cache.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:49:47 -0700
Message-ID: <5390c9db.yqfghHIZTqu+E4RE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com

Subject: [merged] memcg-un-export-__memcg_kmem_get_cache.patch removed from -mm tree
To: vdavydov@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:47 -0700


The patch titled
     Subject: memcg: un-export __memcg_kmem_get_cache
has been removed from the -mm tree.  Its filename was
     memcg-un-export-__memcg_kmem_get_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: un-export __memcg_kmem_get_cache

It is only used in slab and should not be used anywhere else so there is
no need in exporting it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-un-export-__memcg_kmem_get_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-un-export-__memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -3513,7 +3513,6 @@ out:
 	rcu_read_unlock();
 	return cachep;
 }
-EXPORT_SYMBOL(__memcg_kmem_get_cache);
 
 /*
  * We need to verify if the allocation against current->mm->owner's memcg is
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

