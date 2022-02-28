Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F9CC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiB1At2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiB1At1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B873DDCB
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5976F6120A
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46D0C340E9;
        Mon, 28 Feb 2022 00:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009327;
        bh=gGH8KvFfSl6whhYNuxEiXYSI3pnUUfzW2p2WIHv7Rpg=;
        h=Date:To:From:Subject:From;
        b=Q8kiobsQsClHMvvaewwrv/qSFJAUvYHOpRX9AkZ1t4qW9RZ1IhYrnF+K8JEwE/SVA
         MAyS57V/TpQYFHlKltota57fuqczhyKab1WWdojKE9X34bkQ7eT91EkuyPzwj96jDa
         4A/xfH6hni1LID16pavZc7MyqAaBFH4V6Ng7vHFQ=
Date:   Sun, 27 Feb 2022 16:48:47 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, hannes@cmpxchg.org, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-add-myself-as-a-memcg-co-maintainer-as-well.patch removed from -mm tree
Message-Id: <20220228004847.B46D0C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Shakeel as a memcg co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-a-memcg-co-maintainer-as-well.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

memcg-replace-in_interrupt-with-in_task.patch
memcg-refactor-mem_cgroup_oom.patch
memcg-unify-force-charging-conditions.patch
selftests-memcg-test-high-limit-for-single-entry-allocation.patch
memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

