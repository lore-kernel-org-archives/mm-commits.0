Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72782C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 07:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbiBYHR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 02:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238078AbiBYHR6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 02:17:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0249722A242
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 23:17:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76A2361B0B
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 07:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9B0C340E7;
        Fri, 25 Feb 2022 07:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645773445;
        bh=Ru0HDSLMGkvhj3Fp8CgMgAcAh3Oavp1+YpvF5AX52Zo=;
        h=Date:To:From:Subject:From;
        b=BGdHW2jqCWzZIqgKGWRpyQyCaDgyxyKjlzIvO/8KGoar+UoQtzjEXT80aT52umkbo
         VIHHzeaWhrmCusEsXLzaQlw6W3/s0z0bv65ST6ElkO9vcV4v6KF/MGtKYUhu0Pnzy8
         fQ5HSDga3Ewoo0FdRrZ/h0x/xjjAwgAag/Ho6Zos=
Date:   Thu, 24 Feb 2022 23:17:25 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, hannes@cmpxchg.org, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-a-memcg-co-maintainer-as-well.patch added to -mm tree
Message-Id: <20220225071725.CF9B0C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Shakeel as a memcg co-maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-myself-as-a-memcg-co-maintainer-as-well.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-myself-as-a-memcg-co-maintainer-as-well.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-myself-as-a-memcg-co-maintainer-as-well.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from shakeelb@google.com are

maintainers-add-myself-as-a-memcg-co-maintainer-as-well.patch
memcg-replace-in_interrupt-with-in_task.patch
memcg-refactor-mem_cgroup_oom.patch
memcg-unify-force-charging-conditions.patch
selftests-memcg-test-high-limit-for-single-entry-allocation.patch
memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

