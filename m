Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BA6C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiLLDbO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiLLDbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E4FD2C2
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38F7960EDD
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9040BC433EF;
        Mon, 12 Dec 2022 03:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815870;
        bh=ilbQg1MnIxAi8FT7NDuvtICRd6DXlqjS7YcJcFbl/ac=;
        h=Date:To:From:Subject:From;
        b=QXXjqI3o+zaFsRh0Fy+fNstWNB01u31pCwuvH3PLEY7B1RIXK0A3zkRJEqotiihvC
         /B5OF5TuAEKsu9nuPddj2Qu/4Dbt2IPSzbL/ZovAnt97QHLbjIlBS4ZaWC081/Zfn2
         86BTETNHJXk95Q0eCtdiquzCeEon2vMf6fJsr86c=
Date:   Sun, 11 Dec 2022 19:31:09 -0800
To:     mm-commits@vger.kernel.org, iskren.chernev@gmail.com,
        me@iskren.info, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-email-for-iskren-chernev.patch removed from -mm tree
Message-Id: <20221212033110.9040BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update email for Iskren Chernev
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-for-iskren-chernev.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Iskren Chernev <me@iskren.info>
Subject: mailmap: update email for Iskren Chernev
Date: Thu, 24 Nov 2022 13:43:56 +0200

I'm sunsetting my gmail account and moving to personal domain.

Link: https://lkml.kernel.org/r/20221124114356.2187901-1-me@iskren.info
Signed-off-by: Iskren Chernev <me@iskren.info>
Acked-by: Iskren Chernev <iskren.chernev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-for-iskren-chernev
+++ a/.mailmap
@@ -227,6 +227,7 @@ Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
 Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
+Iskren Chernev <me@iskren.info> <iskren.chernev@gmail.com>
 Kalle Valo <kvalo@kernel.org> <kvalo@codeaurora.org>
 Kalyan Thota <quic_kalyant@quicinc.com> <kalyan_t@codeaurora.org>
 Kay Sievers <kay.sievers@vrfy.org>
_

Patches currently in -mm which might be from me@iskren.info are


