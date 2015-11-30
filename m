From: akpm@linux-foundation.org
Subject: +
 maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
 added to -mm tree
Date: Mon, 30 Nov 2015 13:27:15 -0800
Message-ID: <565cbf33.4TZC3S1PUWdndmTw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbK3V1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 16:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: make Vladimir co-maintainer of the memory controller
has been added to the -mm tree.  Its filename is
     maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: MAINTAINERS: make Vladimir co-maintainer of the memory controller

Vladimir architected and authored much of the current state of the memcg's
slab memory accounting and tracking.  Make sure he gets CC'd on bug
reports ;-)

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-make-vladimir-co-maintainer-of-the-memory-controller MAINTAINERS
--- a/MAINTAINERS~maintainers-make-vladimir-co-maintainer-of-the-memory-controller
+++ a/MAINTAINERS
@@ -2982,6 +2982,7 @@ F:	kernel/cpuset.c
 CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
+M:	Vladimir Davydov <vdavydov@virtuozzo.com>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

