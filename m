Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B94C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  8 Dec 2022 22:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiLHW7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Dec 2022 17:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiLHW7M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Dec 2022 17:59:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2043E78BA6
        for <mm-commits@vger.kernel.org>; Thu,  8 Dec 2022 14:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F9D6209B
        for <mm-commits@vger.kernel.org>; Thu,  8 Dec 2022 22:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09497C433EF;
        Thu,  8 Dec 2022 22:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670540350;
        bh=5Dadym5AP3IBIPZNeix1Ff7rTwd5+gFRE3LgY/8xZds=;
        h=Date:To:From:Subject:From;
        b=DyFIwBgy3hrHkzsRWuc5KMZtAJCb2IZbdfFJjsLVnCphW5+trBBZnxTwVNEIUy9SK
         KD+sNYYtelmtwMFVrgxT73PxNY1+XSah9mbGk9Y01PW9KnwwcOJRh/Y1X0ttDTO0OZ
         85p0tmQAttKCkwHXeXKiq5yO2eutqkUJg6AB7Hqc=
Date:   Thu, 08 Dec 2022 14:59:09 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-muchun-songs-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20221208225910.09497C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Muchun Song's email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-muchun-songs-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-muchun-songs-email.patch

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
Subject: MAINTAINERS: update Muchun Song's email
Date: Thu, 8 Dec 2022 19:55:48 +0800

I'm moving to the @linux.dev account.  Map my old addresses and update it
to my new address.

Link: https://lkml.kernel.org/r/20221208115548.85244-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

maintainers-update-muchun-songs-email.patch

