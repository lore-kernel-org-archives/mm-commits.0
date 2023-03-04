Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7FDC678D5
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 19:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCDTbN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 14:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCDTbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 14:31:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51D71ABF3
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 11:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D226B808D4
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 19:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DA8C433D2;
        Sat,  4 Mar 2023 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677958269;
        bh=DHkJ9izXmkiKtcKPz76zQy7WNvHz4ZomyuK9SBJh49A=;
        h=Date:To:From:Subject:From;
        b=ot34Pg2ozPSIGe+/NSIPkh1P5NwSHuITHdS2iuEgnoMTaunldqlFIayG21KKHfADJ
         YhpsyGW4m6U811Qf3ND6oshUSfTQUpGqPrRDtOti2a/jSSBv56C4FdiM09SVLwVCil
         AyR3IY1G96lsYB0YJ3wzYZgXKa/ZelSHsOJpbT2g=
Date:   Sat, 04 Mar 2023 11:31:08 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch removed from -mm tree
Message-Id: <20230304193109.23DA8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch

This patch was dropped because it was folded into zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix
Date: Fri Mar  3 03:24:35 PM PST 2023

fix comment spello

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix
+++ a/mm/zsmalloc.c
@@ -647,7 +647,7 @@ static int zs_stats_size_show(struct seq
 		spin_lock(&pool->lock);
 
 		/*
-		 * Replecate old behaviour for almost_full and almost_empty
+		 * Replicate old behaviour for almost_full and almost_empty
 		 * stats.
 		 */
 		for (fg = ZS_INUSE_RATIO_70; fg <= ZS_INUSE_RATIO_99; fg++)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch

