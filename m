Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55893C6FD1F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCWBeq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjCWBeR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:34:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CEFFF08
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF8D623A3
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A86C433D2;
        Thu, 23 Mar 2023 01:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535150;
        bh=VHsHgMLjyslor/aGW0teo1ns66JD8sJFTs8UgXwsDgg=;
        h=Date:To:From:Subject:From;
        b=nWgYcdqCR7dN1C/i/yJGe8vl3IAOZva+H+mMbhybqdl6f2Zz7hIvIjYH9LVCky6ip
         b3f8BIsialDAxwz2aUsIYyalmT4J5/ktuJ2CPIRp/qNO32fnW8M8quBu+z98xUkymV
         qDvCMCfx1fYRBqpo93UACT97L/jf5OA1OdllHrK4=
Date:   Wed, 22 Mar 2023 18:32:29 -0700
To:     mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        l.goehrs@pengutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-leonard-gohrs.patch removed from -mm tree
Message-Id: <20230323013230.82A86C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: .mailmap: add entry for Leonard Göhrs
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-leonard-gohrs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leonard Göhrs <l.goehrs@pengutronix.de>
Subject: .mailmap: add entry for Leonard Göhrs
Date: Tue, 21 Mar 2023 15:55:25 +0100

My very first kernel commit:

  e4e1d47c7906 ("ALSA: ppc: remove redundant checks in PS3 driver probe")

was sent with the umlaut in my last name transcribed (Göhrs -> Goehrs).

Add a mailmap entry so all my commits use the same name.

Link: https://lkml.kernel.org/r/20230321145525.1317230-1-l.goehrs@pengutronix.de
Signed-off-by: Leonard Göhrs <l.goehrs@pengutronix.de>
Acked-by: Uwe Kleine-Knig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-entry-for-leonard-gohrs
+++ a/.mailmap
@@ -260,6 +260,7 @@ Krzysztof Kozlowski <krzk@kernel.org> <k
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Kuogee Hsieh <quic_khsieh@quicinc.com> <khsieh@codeaurora.org>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
+Leonard Göhrs <l.goehrs@pengutronix.de>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
 Leon Romanovsky <leon@kernel.org> <leon@leon.nu>
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
_

Patches currently in -mm which might be from l.goehrs@pengutronix.de are


