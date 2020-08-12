Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69280C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4526B2087C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597193829;
	bh=9fbgW0jeHM26OanGpqXe4YzHgU96xe5Dr6R+tkmDl1k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UzI58UOoVk5WtJWgbHo5griBxa1QxOD5txRVzsA2wYWuzCMLYCyfPoJ2+nHTYTOeF
	 LnijupoxHUWLrurgNsY63vsSsjVfYUl71Lxetvb2kUQreTrxXpbP1WGa5YRlIPJTQT
	 ySm2UYSaitY4sCBtu8XFEftBx/UeYCq9kQNi5D+A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLA5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLA5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 20:57:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 421322078B;
        Wed, 12 Aug 2020 00:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597193827;
        bh=9fbgW0jeHM26OanGpqXe4YzHgU96xe5Dr6R+tkmDl1k=;
        h=Date:From:To:Subject:From;
        b=mkh75A+sAusPo+AqQIWcgvBr3fzShBYrgINmuacKnU/XRivN8VEWabu7V3Pkjda69
         CFmO93e3kgm551Opt+cK0T/j1Z71mJ/C6fGcB68q4/PnyAA+U11C5NnesSbOWd1jgC
         ifh+n+kTtFxXtTXE5jG/gKu64A5UrkY2gVT3pUZc=
Date:   Tue, 11 Aug 2020 17:57:06 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, cuibixuan@huawei.com, dennis@kernel.org, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch removed from
 -mm tree
Message-ID: <20200812005706.MTFCtTvH7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3
has been removed from the -mm tree.  Its filename was
     mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch

This patch was dropped because it was folded into mm-memcg-percpu-per-memcg=
-percpu-memory-statistics.patch

------------------------------------------------------
=46rom: Roman Gushchin <guro@fb.com>
Subject: mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3

Link: http://lkml.kernel.org/r/20200623184515.4132564-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Bixuan Cui <cuibixuan@huawei.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-percpu-per-memcg-percpu-memory-st=
atistics-v3
+++ a/include/linux/memcontrol.h
@@ -340,11 +340,11 @@ struct mem_cgroup {
=20
 extern struct mem_cgroup *root_mem_cgroup;
=20
-static __always_inline bool memcg_stat_item_in_bytes(enum memcg_stat_item =
item)
+static __always_inline bool memcg_stat_item_in_bytes(int idx)
 {
-	if (item =3D=3D MEMCG_PERCPU_B)
+	if (idx =3D=3D MEMCG_PERCPU_B)
 		return true;
-	return vmstat_item_in_bytes(item);
+	return vmstat_item_in_bytes(idx);
 }
=20
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

