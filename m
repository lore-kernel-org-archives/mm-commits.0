Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41587C43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 22:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiFKWIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 18:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiFKWIl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 18:08:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9FC40A2C
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 15:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB3BB80B3E
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 22:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C8FC3411C;
        Sat, 11 Jun 2022 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654985317;
        bh=NE2jDmU52apoYwiRVUsJnvw2T15KIRkU7W+Cj695AuU=;
        h=Date:To:From:Subject:From;
        b=BtLqyp+3Pv0iE3ri8Siq6U8JbT5QZQR5O1sLuXQ+dTOD8gvQR8tKKgRTI+LWyV3ik
         XhsY4DnwQWOF8VCvD+JTfvBGsaIINU+fhWOSSiXJYgMFqogrRvQgMI6GEnu5g3qvrJ
         i/LGMXUPuOVhfbar4LaG+l9cRW3BYHeXABDCOeaM=
Date:   Sat, 11 Jun 2022 15:08:36 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy.patch added to mm-hotfixes-unstable branch
Message-Id: <20220611220837.75C8FC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: reference to tools/cgroup/memcg_slabinfo.py
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy.patch

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
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm: memcontrol: reference to tools/cgroup/memcg_slabinfo.py
Date: Fri, 10 Jun 2022 02:44:52 +0000

There is no slabinfo.py in tools/cgroup, but has memcg_slabinfo.py instead.

Link: https://lkml.kernel.org/r/20220610024451.744135-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy
+++ a/mm/memcontrol.c
@@ -4859,7 +4859,7 @@ static int mem_cgroup_slab_show(struct s
 {
 	/*
 	 * Deprecated.
-	 * Please, take a look at tools/cgroup/slabinfo.py .
+	 * Please, take a look at tools/cgroup/memcg_slabinfo.py .
 	 */
 	return 0;
 }
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-memcontrol-reference-to-tools-cgroup-memcg_slabinfopy.patch

