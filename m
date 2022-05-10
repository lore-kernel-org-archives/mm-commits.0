Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DB2C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbiEJEP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiEJEOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9BE165BA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFF1161735
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8F4C385A6;
        Tue, 10 May 2022 04:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155846;
        bh=iTLh9JrIcZoFpDaQUInDaHg/5DRZV0SEJp8QE0fOe+A=;
        h=Date:To:From:Subject:From;
        b=vvMurWzl2Jr0cOVJkwt4JRFpQsUNZFrbIEXHxJhclkAdQuNxtkzpQGkOAAVVm02Tf
         Vb7OEKNVlKewHax7m7COBJKfzV5uKQ2RKOFwuFSt0UpfCyXTx1Krbpdk4i34cx62PK
         L3Vd/7j47BX4jyjYXwESnwxqByNOjZSfIRpRiQpE=
Date:   Mon, 09 May 2022 21:10:45 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, chris@chrisdown.name, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-corresponding-kselftests-to-memcg-entry.patch removed from -mm tree
Message-Id: <20220510041046.4D8F4C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add corresponding kselftests to memcg entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-corresponding-kselftests-to-memcg-entry.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add corresponding kselftests to memcg entry

List memory control and kernel memory control kselftests in the memory
resource controller entry.

Link: https://lkml.kernel.org/r/20220415000133.3955987-5-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Vernet <void@manifault.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-corresponding-kselftests-to-memcg-entry
+++ a/MAINTAINERS
@@ -5027,6 +5027,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
+F:	tools/testing/selftests/cgroup/test_kmem.c
+F:	tools/testing/selftests/cgroup/test_memcontrol.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu@intel.com>
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


