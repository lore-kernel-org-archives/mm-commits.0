From: akpm@linux-foundation.org
Subject: +
 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch added
 to -mm tree
Date: Sat, 20 Jun 2020 17:21:05 -0700
Message-ID: <20200621002105.MnU1h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgFUAVG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 20:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, guro@fb.com, dennis@kernel.org, cl@linux.com, akpm@linux-foundation.org


The patch titled
     Subject: mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix

move unreachable code, per Roman

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix
+++ a/mm/percpu.c
@@ -1440,8 +1440,8 @@ static struct pcpu_chunk *pcpu_alloc_chu
 
 #ifdef CONFIG_MEMCG_KMEM
 objcg_fail:
-#endif
 	pcpu_mem_free(chunk->md_blocks);
+#endif
 md_blocks_fail:
 	pcpu_mem_free(chunk->bound_map);
 bound_map_fail:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
