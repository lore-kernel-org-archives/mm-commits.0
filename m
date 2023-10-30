Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27D5C4167D
	for <mm-commits@archiver.kernel.org>; Mon, 30 Oct 2023 19:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjJ3TLB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Oct 2023 15:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjJ3TLA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Oct 2023 15:11:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A98DA
        for <mm-commits@vger.kernel.org>; Mon, 30 Oct 2023 12:10:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A8EC433CB;
        Mon, 30 Oct 2023 19:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698693057;
        bh=8yWecSZqE+P/k7NyeX9RzGr4w/MuO9fMU9dzfYpC1Lk=;
        h=Date:To:From:Subject:From;
        b=oqOsxgDAWUpxbges+MaIPQjSU/srykttEj+GcQIq+wIQFvO+8rExqCX1AEpNb/1yp
         vAxJHu7VqgjnBjKXCQBf+tKwlrOU/8DrnxpdggDMHOVnLRIvTY8Z8++k3s+j32rrAs
         3g30L/bwULVoowpcLJKKP8G9Elmls2g4sFAP1Nlo=
Date:   Mon, 30 Oct 2023 12:10:56 -0700
To:     mm-commits@vger.kernel.org, quic_bjorande@quicinc.com,
        o.rempel@pengutronix.de, kuba@kernel.org, konrad.dybcio@linaro.org,
        heiko@sntech.de, axboe@kernel.dk, claudiu.beznea@tuxon.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-claudiu-beznea.patch added to mm-nonmm-unstable branch
Message-Id: <20231030191057.59A8EC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email address for Claudiu Beznea
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-address-for-claudiu-beznea.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-claudiu-beznea.patch

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
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Subject: mailmap: update email address for Claudiu Beznea
Date: Mon, 30 Oct 2023 08:36:32 +0200

Claudiu Beznea's Microchip email address is no longer valid.
Map it to a valid one.

Link: https://lkml.kernel.org/r/20231030063632.1707372-1-claudiu.beznea@tuxon.dev
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-claudiu-beznea
+++ a/.mailmap
@@ -129,6 +129,7 @@ Christian Brauner <brauner@kernel.org> <
 Christian Marangi <ansuelsmth@gmail.com>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
+Claudiu Beznea <claudiu.beznea@tuxon.dev> <claudiu.beznea@microchip.com>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
_

Patches currently in -mm which might be from claudiu.beznea@tuxon.dev are

mailmap-update-email-address-for-claudiu-beznea.patch

