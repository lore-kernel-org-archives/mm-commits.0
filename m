From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch
 removed from -mm tree
Date: Wed, 20 Jul 2016 15:42:25 -0700
Message-ID: <578ffe51.KZtMysNgzDSMfD3C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbcGTWm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2016 18:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix cgroup creation failure after many small jobs fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch

This patch was dropped because it was folded into mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix cgroup creation failure after many small jobs fix

init the IDR

Link: http://lkml.kernel.org/r/20160621154601.GA22431@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix
+++ a/mm/memcontrol.c
@@ -4081,7 +4081,7 @@ static struct cftype mem_cgroup_legacy_f
  * those references are manageable from userspace.
  */
 
-static struct idr mem_cgroup_idr;
+static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_get(struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
cgroup-remove-unnecessary-0-check-from-css_from_id.patch
mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch
mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch

