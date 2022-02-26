Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70488C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 03:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiBZDLx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 22:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiBZDLv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 22:11:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE52671D9
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 19:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD741B832D3
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 03:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF43C340E7;
        Sat, 26 Feb 2022 03:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645845075;
        bh=xUi79h8rf32yrZB0YMagwcrqpugxUeAoZLxduOk3zjA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=VCSHjWnuHN0mGQQgzOBQct7HXk1gfKOaBEI6Yx6U7Vv36yDvjrAvkJEelBaSPX0B9
         GYW4WdOKNIJpiWhqrB988oSnWwV5gavsvhA3U79NJB8agRuvTRf2XOpWTWr2DzMPpI
         ZVtDfb5VTVm52wEIto8r6bwM5fWPS1WJtHIykQi8=
Date:   Fri, 25 Feb 2022 19:11:14 -0800
To:     roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 08/12] MAINTAINERS: remove Vladimir from memcg maintainers
Message-Id: <20220226031115.5EF43C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: MAINTAINERS: remove Vladimir from memcg maintainers

Link: https://lkml.kernel.org/r/4ad1f8da49d7b71c84a0c15bd5347f5ce704e730.1645608825.git.vdavydov.dev@gmail.com
Signed-off-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-memcg-maintainers
+++ a/MAINTAINERS
@@ -4913,7 +4913,6 @@ F:	kernel/cgroup/cpuset.c
 CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
-M:	Vladimir Davydov <vdavydov.dev@gmail.com>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
_
