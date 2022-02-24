Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265D2C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiBXEge (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBXEgd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:36:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7293C1EA2B3
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CD9CB823FB
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA0BC340E9;
        Thu, 24 Feb 2022 04:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645677361;
        bh=9X5c+kzcjeM3zWfy48R0cENArmdggaeC9kWAKNIbsDA=;
        h=Date:To:From:Subject:From;
        b=1LGlZ2NbvnRJ7Jn7fbEYdTxuntMQMpA7qLnYjLklxzIgpcbYttiMruTETADmQkWwj
         QcknbVeU7cc9DNyS4msxNOLUh1fKRnFU8DcakoxsFUjdY78VuEShZuRwJOe0V0KV+E
         engjTO4Q9ZXOoEKELZsAdZe3jTJ7pYvq0BdT2U/Y=
Date:   Wed, 23 Feb 2022 20:36:01 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself-from-memcg-maintainers.patch added to -mm tree
Message-Id: <20220224043601.BCA0BC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove Vladimir from memcg maintainers
has been added to the -mm tree.  Its filename is
     maintainers-remove-myself-from-memcg-maintainers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-myself-from-memcg-maintainers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-myself-from-memcg-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: MAINTAINERS: remove Vladimir from memcg maintainers

Link: https://lkml.kernel.org/r/4ad1f8da49d7b71c84a0c15bd5347f5ce704e730.1645608825.git.vdavydov.dev@gmail.com
Signed-off-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
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

maintainers-remove-myself-from-memcg-maintainers.patch

