Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CE8C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Apr 2022 04:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiDJEl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Apr 2022 00:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiDJElV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Apr 2022 00:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AA31900A
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 21:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D504BB80B8C
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 04:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F976C385A1;
        Sun, 10 Apr 2022 04:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565548;
        bh=a670ZhOjrfnLLMMZenUpHHOluhw5izgffYJcmU2mBLw=;
        h=Date:To:From:Subject:From;
        b=kNc30zGmG1TYL3RozfvSGniPbW1uNHIMY8kqBYfVGLi39CTp4QJtVL1M4bRhvxc3m
         WC3OHSvh7VhTcGPuj6o6UlpcxQbaI9ikwsLhhRD8aG3MD1O0H+YUjACCkL/iwZ0Tzk
         EpuQPj/Uy7dFNOk7rkvpOwWGmGaK5VawVbCP2k9c=
Date:   Sat, 09 Apr 2022 21:39:07 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mailmap-update-vasily-averins-email-address.patch removed from -mm tree
Message-Id: <20220410043908.8F976C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Vasily Averin's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-vasily-averins-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vasily.averin@linux.dev>
Subject: mailmap: update Vasily Averin's email address

I'm moving to a @linux.dev account. Map my old addresses.

Link: https://lkml.kernel.org/r/737c7c2b-cdab-63ee-be90-cb33316c9657@linux.dev
Signed-off-by: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-update-vasily-averins-email-address
+++ a/.mailmap
@@ -391,6 +391,10 @@ Uwe Kleine-König <ukleinek@strlen.de>
 Uwe Kleine-König <ukl@pengutronix.de>
 Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
+Vasily Averin <vasily.averin@linux.dev> <vvs@virtuozzo.com>
+Vasily Averin <vasily.averin@linux.dev> <vvs@openvz.org>
+Vasily Averin <vasily.averin@linux.dev> <vvs@parallels.com>
+Vasily Averin <vasily.averin@linux.dev> <vvs@sw.ru>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@intel.com>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@linux.intel.com>
 Vinod Koul <vkoul@kernel.org> <vkoul@infradead.org>
_

Patches currently in -mm which might be from vasily.averin@linux.dev are


