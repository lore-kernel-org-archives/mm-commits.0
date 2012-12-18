From: akpm@linux-foundation.org
Subject: [folded-dropped] memcg-kmem-accounting-basic-infrastructure-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:13:16 -0800
Message-ID: <20121218221317.3D176200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:51568 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2LRWNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:13:22 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so67856lag.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:13:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, fweisbec@redhat.com, glommer@parallels.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-slub-struct-memcg_params-fix
has been removed from the -mm tree.  Its filename was
     memcg-kmem-accounting-basic-infrastructure-fix.patch

This patch was dropped because it was folded into memcg-kmem-accounting-basic-infrastructure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slab-slub-struct-memcg_params-fix

MEMCG_MMEM only works with slab and slub

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~memcg-kmem-accounting-basic-infrastructure-fix init/Kconfig
--- a/init/Kconfig~memcg-kmem-accounting-basic-infrastructure-fix
+++ a/init/Kconfig
@@ -882,6 +882,7 @@ config MEMCG_SWAP_ENABLED
 config MEMCG_KMEM
 	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
 	depends on MEMCG && EXPERIMENTAL
+	depends on SLUB || SLAB
 	default n
 	help
 	  The Kernel Memory extension for Memory Resource Controller can limit
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch

