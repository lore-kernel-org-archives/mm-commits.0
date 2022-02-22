Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F814C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 01:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiBVBzn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 20:55:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiBVBzm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 20:55:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3E325C4B
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 17:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A0C614C8
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 01:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9351BC340E9;
        Tue, 22 Feb 2022 01:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645494917;
        bh=vk4Tq1ppQ2/BX+dCh1Wli1Ziwy39TOb6ayadTm2qcic=;
        h=Date:To:From:Subject:From;
        b=bjpivaFZfGSQR6/u7B2+x3I7ch1SdOMNO0FgVisXPXxO0P0X6WkjFfW2tjOZ5GbrV
         NLEzuDl9P4/BA4oaf7sHizoMfryd1EXp2scctBI92uLo7opQddUB73BpikZB4irWmp
         sjA2EC8iFp9kAPEmY5lTANd5sfwINBWFgTxsAMt8=
Date:   Mon, 21 Feb 2022 17:55:17 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@kernel.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-a-memcg-co-maintainer.patch added to -mm tree
Message-Id: <20220222015517.9351BC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Roman as a memcg co-maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-myself-as-a-memcg-co-maintainer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-myself-as-a-memcg-co-maintainer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-myself-as-a-memcg-co-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add Roman as a memcg co-maintainer

Add myself as a memcg co-maintainer.  My primary focus over last few years
was the kernel memory accounting stack, but I do work on some other parts
of the memory controller as well.

Link: https://lkml.kernel.org/r/20220221233951.659048-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-memcg-co-maintainer
+++ a/MAINTAINERS
@@ -4915,6 +4915,7 @@ CONTROL GROUP - MEMORY RESOURCE CONTROLL
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Vladimir Davydov <vdavydov.dev@gmail.com>
+M:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

maintainers-add-myself-as-a-memcg-co-maintainer.patch

