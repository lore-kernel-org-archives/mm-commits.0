Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE9EC4321E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 20:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiCYUEY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiCYUDI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 16:03:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3EC290895
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 12:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D0A3B828F7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 19:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3764C340ED;
        Fri, 25 Mar 2022 19:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648237770;
        bh=mV/39ZVuA/EpPCFLEiGGfxg7D6Mr4e1jyVuxK+NZAi8=;
        h=Date:To:From:Subject:From;
        b=IBJeJaJedW6NqD8qdZ0abucouij6arUcxpKLiZ+P8qM6FiK2yUFEzPcjUsUcB+nC8
         LxDGhuMiZmASRl6x4cepkPWWg2TrbpqPFNOnQ7s6sCBjSj7ycoP6PZs4sDsFiy2C8B
         h7HOiH4TbIBEyFf9v9MudnWxXz5XZYz0Em4qa6G0=
Date:   Fri, 25 Mar 2022 12:49:30 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-vasily-averins-email-address.patch added to -mm tree
Message-Id: <20220325194930.D3764C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Vasily Averin's email address
has been added to the -mm tree.  Its filename is
     mailmap-update-vasily-averins-email-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-vasily-averins-email-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-vasily-averins-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -389,6 +389,10 @@ Uwe Kleine-König <ukleinek@strlen.de>
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

mailmap-update-vasily-averins-email-address.patch

