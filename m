Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF1BC43217
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 20:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbiDHULU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239420AbiDHULR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 16:11:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929AF13CC6
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 13:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BB1F61DAE
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 20:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840A2C385A3;
        Fri,  8 Apr 2022 20:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649448551;
        bh=INxKj1/Eanumd3G10GxRywr5ChlEaetXXPiQm7G9d88=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=z+f5MKcgHh3a6wz7x5/NIrVot0I3Rb+4K//+4efkNJ0PSiTiaTuahUUB4EmM//drT
         CgboOeLOm2qVgSQD1RQNPjGUJh9iPqs9X5x48klF3SYiXg/wLohu7Pvh1pbPnMDrB/
         EpT6v9YMd4MWd+MlMeQGakFbZhVK4jSSM67lMQ+s=
Date:   Fri, 08 Apr 2022 13:09:10 -0700
To:     vasily.averin@linux.dev, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 7/9] mailmap: update Vasily Averin's email address
Message-Id: <20220408200911.840A2C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
