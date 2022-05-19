Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591AAC43219
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiESW2m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245513AbiESW2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:28:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9647B76281
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23613B828AF
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CBAC385AA;
        Thu, 19 May 2022 22:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999250;
        bh=RG3w8TwUlTBPe4RmeWiRiPrKawu6s9bVXEh3yvp0Um4=;
        h=Date:To:From:Subject:From;
        b=nz5ZQI8oTRPX/CpLCQ2HlwPOMVlmKT6CkJyQBJ45uWYn24pygsV1S6QUFPpF42wtS
         EuuDC5vbbfruAcxk6ONS4XLWkI88cfdMryG7pyzXXZCNPpCX0EjG/5SvGlSfne8XjA
         Di0WKeWR/D36mrC/eXCZaokXsKvGs+27tAVL9h18=
Date:   Thu, 19 May 2022 15:27:30 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        bh1scw@gmail.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-myself-as-a-memcg-reviewer.patch removed from -mm tree
Message-Id: <20220519222730.C9CBAC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add Muchun as a memcg reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-a-memcg-reviewer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: MAINTAINERS: add Muchun as a memcg reviewer
Date: Tue, 17 May 2022 22:33:20 +0800

I have been focusing on mm for the past two years.  e.g.  developing,
fixing bugs, reviewing.  I have fixed lots of races (including memcg).  I
would like to help people working on memcg or related by reviewing their
work.  Let me be Cc'd on patches related to memcg.

Link: https://lkml.kernel.org/r/20220517143320.99649-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: FanJun Kong <bh1scw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-memcg-reviewer
+++ a/MAINTAINERS
@@ -5023,6 +5023,7 @@ M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
 M:	Shakeel Butt <shakeelb@google.com>
+R:	Muchun Song <songmuchun@bytedance.com>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


