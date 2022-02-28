Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3630EC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiB1At1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiB1At1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AF63DDC5
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:48:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6818661206
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB570C340EE;
        Mon, 28 Feb 2022 00:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009326;
        bh=XrnvXpV4riRiBZ9l58YLMmMh4AtaVTG1Nv+Z0W03BzM=;
        h=Date:To:From:Subject:From;
        b=Udeyi+D+QKdGAgGMVzs7/ZUii3jX+vGlaA+VH6Cz255eWWdQklKxoULtbuwKLrT6m
         uUkWMQSQ4Fnby2eZgQw+MiUv0sv9y5l9mVddVtKKLG/4FecGd51KYzt0rD5/0bNUQF
         dcGfQxh6o1uIv/JTCFdTqVnDdpPcMbDOe8ie9IfI=
Date:   Sun, 27 Feb 2022 16:48:46 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-remove-myself-from-memcg-maintainers.patch removed from -mm tree
Message-Id: <20220228004846.BB570C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove Vladimir from memcg maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-from-memcg-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vdavydov.dev@gmail.com are


