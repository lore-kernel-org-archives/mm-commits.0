Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAE6C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 03:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiBZDLx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 22:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiBZDLw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 22:11:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858822671E2
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 19:11:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED68061E15
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 03:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D1BC36AE7;
        Sat, 26 Feb 2022 03:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645845078;
        bh=37yVslau23+pEANbG7vpT44TEzPPTAW+HLL06jOs60w=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=eWKMy4k9rsCx2zf+ywlgsJRFOAaMYtt24fcbozY+kZTy0UXDpJcGx2U5u+yDiqJMm
         FW+6IRzzu6L283Ep02weLsiCRqJEi21A+Th9ouQRkhhqQnSd5Bst+dfXHn2oWiVOYG
         ZahK4OC0JQZpUxlXMShceAJl0USODHyoiqxmJulM=
Date:   Fri, 25 Feb 2022 19:11:17 -0800
To:     roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        shakeelb@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 09/12] MAINTAINERS: add Shakeel as a memcg co-maintainer
Message-Id: <20220226031118.50D1BC36AE7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: MAINTAINERS: add Shakeel as a memcg co-maintainer

I have been contributing and reviewing to the memcg codebase for last
couple of years.  So, making it official.

Link: https://lkml.kernel.org/r/20220224060148.4092228-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-memcg-co-maintainer-as-well
+++ a/MAINTAINERS
@@ -4914,6 +4914,7 @@ CONTROL GROUP - MEMORY RESOURCE CONTROLL
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
+M:	Shakeel Butt <shakeelb@google.com>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
_
