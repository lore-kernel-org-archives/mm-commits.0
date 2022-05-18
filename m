Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6289CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 18:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbiERSh5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 14:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiERSh5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 14:37:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E5120E0AC
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 11:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBCAAB82180
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 18:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814C9C34100;
        Wed, 18 May 2022 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652899073;
        bh=IsJ4YGjmu3/iy9F9iVS+gKbHhqSJMbI3U4Bgiqw7e4g=;
        h=Date:To:From:Subject:From;
        b=ulWcJje18NOhcypF5FqlkgbrUF9Y7UzVKxL0zdFd1Dco0WNXQ+GBCAbKyqk25grsP
         +N1HGltOGfED6wQ3dzxvT2o9YWjwkIO0LHA8k6lHz3Gkm5WSKdSgAERGVz5z7tuLsJ
         cYYcSWxX5pY5duUcM5YmrShnIeZmB5IJY6CrWsqI=
Date:   Wed, 18 May 2022 11:37:52 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        bh1scw@gmail.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-a-memcg-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20220518183753.814C9C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Muchun as a memcg reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-myself-as-a-memcg-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-a-memcg-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

maintainers-add-myself-as-a-memcg-reviewer.patch

