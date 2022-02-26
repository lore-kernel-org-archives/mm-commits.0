Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AB4C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 03:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiBZDLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 22:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBZDLt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 22:11:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C652671D9
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 19:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF1F0B832D3
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 03:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF1C340EF;
        Sat, 26 Feb 2022 03:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645845072;
        bh=qT1gFEKHfDvEQPef2tMFv7/sOYoIBCgAaeddDX7B284=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ZCu8u2M6IubbLXmwHt/8t2rNtWL8/Mu9STOknx1pjDE0o9uDXOA7TRY5oAJWpgEoC
         unfdjAOX/2S7aQIeobIHJ68tefDnZyVDSo7X5JArrKWMoIl9+4sBDL2oOFQmdavhZg
         HGGIUVtp7bhMUhBqLdT7h1M0gG3VcRXc8KIyyh1k=
Date:   Fri, 25 Feb 2022 19:11:11 -0800
To:     vdavydov.dev@gmail.com, vbabka@suse.cz, mhocko@suse.com,
        hannes@cmpxchg.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 07/12] MAINTAINERS: add Roman as a memcg co-maintainer
Message-Id: <20220226031112.6CEF1C340EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
