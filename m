Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF650C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 21:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKXVrt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXVrs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 16:47:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7C912D36
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 13:47:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36716B8292E
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 21:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB442C433D6;
        Thu, 24 Nov 2022 21:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669326464;
        bh=Qvc4ZON/M1brlQwcbFiuQk56e+R5JxF+GDs2gs3zDAE=;
        h=Date:To:From:Subject:From;
        b=VrrG2G+Cv23eGct7YaPh/9j2VLPxN6fG4pvyZ3QXKfgD271S1sFFGADdxKndFP2WR
         r8xDXAGVJsFX/3g0kesOkne2tzkmrJwcdGWTF6tnpesgKFByaK6DJog8EykiLpTuSI
         OTIOK060bpMOMd/je4wy1/QsJzQh0a6I7JklXiRo=
Date:   Thu, 24 Nov 2022 13:47:44 -0800
To:     mm-commits@vger.kernel.org, iskren.chernev@gmail.com,
        me@iskren.info, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-for-iskren-chernev.patch added to mm-nonmm-unstable branch
Message-Id: <20221124214744.CB442C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email for Iskren Chernev
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-for-iskren-chernev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-for-iskren-chernev.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
@@ -228,6 +228,7 @@ Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
 Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
+Iskren Chernev <me@iskren.info> <iskren.chernev@gmail.com>
 Kalle Valo <kvalo@kernel.org> <kvalo@codeaurora.org>
 Kalyan Thota <quic_kalyant@quicinc.com> <kalyan_t@codeaurora.org>
 Kay Sievers <kay.sievers@vrfy.org>
_

Patches currently in -mm which might be from me@iskren.info are

mailmap-update-email-for-iskren-chernev.patch

