Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68498C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 02:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLJCmX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 21:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiLJCmF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 21:42:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BFD7B4D1
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 18:42:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D96B82A15
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 02:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64509C433D2;
        Sat, 10 Dec 2022 02:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670640121;
        bh=bkSheZfwHC93gZ/gaDHn73jaz29mwfrGJ1wHZ0DnECc=;
        h=Date:To:From:Subject:From;
        b=XSh0vUEkEjRsY2EddPmgYAN104LEov4/QSVYY8YxkxtE9mN3QuPhRANBca48/m8hX
         uxBi0eIE9HNT94oaXJt95Vc6ndgz3WyRNmel/K0gDm3TewhXC5M/M+deBLnm1H5+vr
         hsV390mA+6vDJaeg5SNV5K1UjgbGoljEyNgI/iRE=
Date:   Fri, 09 Dec 2022 18:42:00 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-muchun-songs-email.patch removed from -mm tree
Message-Id: <20221210024201.64509C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update Muchun Song's email
has been removed from the -mm tree.  Its filename was
     maintainers-update-muchun-songs-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: MAINTAINERS: update Muchun Song's email
Date: Thu, 8 Dec 2022 19:55:48 +0800

I'm moving to the @linux.dev account.  Map my old addresses and update it
to my new address.

Link: https://lkml.kernel.org/r/20221208115548.85244-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    2 ++
 MAINTAINERS |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-muchun-songs-email
+++ a/.mailmap
@@ -373,6 +373,8 @@ Ricardo Ribalda <ribalda@kernel.org> <ri
 Roman Gushchin <roman.gushchin@linux.dev> <guro@fb.com>
 Roman Gushchin <roman.gushchin@linux.dev> <guroan@gmail.com>
 Roman Gushchin <roman.gushchin@linux.dev> <klamm@yandex-team.ru>
+Muchun Song <muchun.song@linux.dev> <songmuchun@bytedance.com>
+Muchun Song <muchun.song@linux.dev> <smuchun@gmail.com>
 Ross Zwisler <zwisler@kernel.org> <ross.zwisler@linux.intel.com>
 Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
--- a/MAINTAINERS~maintainers-update-muchun-songs-email
+++ a/MAINTAINERS
@@ -5299,7 +5299,7 @@ M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
 M:	Shakeel Butt <shakeelb@google.com>
-R:	Muchun Song <songmuchun@bytedance.com>
+R:	Muchun Song <muchun.song@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -9443,7 +9443,7 @@ F:	drivers/net/ethernet/huawei/hinic/
 
 HUGETLB SUBSYSTEM
 M:	Mike Kravetz <mike.kravetz@oracle.com>
-M:	Muchun Song <songmuchun@bytedance.com>
+M:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


