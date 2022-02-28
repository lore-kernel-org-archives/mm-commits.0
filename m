Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AD0C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiB1At1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiB1At0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54A23DA77
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:48:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FAC361205
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CD8C340E9;
        Mon, 28 Feb 2022 00:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009325;
        bh=NQawn3vbIZ0yDCoBC/Jncd8+tArfEhpOHb6DWOL0UdM=;
        h=Date:To:From:Subject:From;
        b=2R9H5eOdL8HgXd5H2MSlxH3fcP2mBBGSsDBa1si371829uSANagt+DNI8yA84oEH3
         tfXMwLWZjjnKv6YCXBqr79a0dRrDG7l9syZoinXozt2ZR+7VLen8FqzbbYUkt72FPm
         yNTUuULEVBREEMMCntyhpSJE6XBYM+Hf/2/7adn8=
Date:   Sun, 27 Feb 2022 16:48:45 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        mhocko@suse.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-add-myself-as-a-memcg-co-maintainer.patch removed from -mm tree
Message-Id: <20220228004845.B3CD8C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Roman as a memcg co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-a-memcg-co-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add Roman as a memcg co-maintainer

Add myself as a memcg co-maintainer.  My primary focus over last few years
was the kernel memory accounting stack, but I do work on some other parts
of the memory controller as well.

Link: https://lkml.kernel.org/r/20220221233951.659048-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-memcg-co-maintainer
+++ a/MAINTAINERS
@@ -4914,6 +4914,7 @@ CONTROL GROUP - MEMORY RESOURCE CONTROLL
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Vladimir Davydov <vdavydov.dev@gmail.com>
+M:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


