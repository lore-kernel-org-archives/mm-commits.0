Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBDBCDB470
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjJKRx7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjJKRx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:53:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AFD8F
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:53:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F69C433C8;
        Wed, 11 Oct 2023 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697046837;
        bh=z7Bs8pOUWzf7eVgT6xqrd2B8GS3zKuWyygOfeddYidQ=;
        h=Date:To:From:Subject:From;
        b=bpkovWuRimQLnE28przcGuF4XS1A1qtvDtBDfCKkHmTsesFuCp4s1QogfH0pgRlH7
         v56hromJCXjX+wxL+qrR6Y56l8+1wPzrG+uT9FfmDB5LZwgHilWnbSZXgv9Ah9OH7l
         DSIDC0T8Ya2xrVgake2xv7N9f5Vel7JdCU90XRUg=
Date:   Wed, 11 Oct 2023 10:53:47 -0700
To:     mm-commits@vger.kernel.org, qyousef@layalina.io, kuba@kernel.org,
        konrad.dybcio@linaro.org, broonie@kernel.org,
        o.rempel@pengutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-correct-email-aliasing-for-oleksij-rempel.patch added to mm-hotfixes-unstable branch
Message-Id: <20231011175355.B2F69C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: correct email aliasing for Oleksij Rempel
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-correct-email-aliasing-for-oleksij-rempel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-correct-email-aliasing-for-oleksij-rempel.patch

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
From: Oleksij Rempel <o.rempel@pengutronix.de>
Subject: mailmap: correct email aliasing for Oleksij Rempel
Date: Wed, 11 Oct 2023 13:25:19 +0200

Ensure the current work email addresses for Oleksij Rempel are preserved
and not overridden by private address.  Alias the alternate work email to
the primary work email address.

Link: https://lkml.kernel.org/r/20231011112519.1427077-1-o.rempel@pengutronix.de
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org> # qcom
Cc: Mark Brown <broonie@kernel.org>
Cc: Qais Yousef <qyousef@layalina.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/.mailmap~mailmap-correct-email-aliasing-for-oleksij-rempel
+++ a/.mailmap
@@ -450,8 +450,8 @@ Oleksandr Natalenko <oleksandr@natalenko
 Oleksij Rempel <linux@rempel-privat.de> <bug-track@fisher-privat.net>
 Oleksij Rempel <linux@rempel-privat.de> <external.Oleksij.Rempel@de.bosch.com>
 Oleksij Rempel <linux@rempel-privat.de> <fixed-term.Oleksij.Rempel@de.bosch.com>
-Oleksij Rempel <linux@rempel-privat.de> <o.rempel@pengutronix.de>
-Oleksij Rempel <linux@rempel-privat.de> <ore@pengutronix.de>
+Oleksij Rempel <o.rempel@pengutronix.de>
+Oleksij Rempel <o.rempel@pengutronix.de> <ore@pengutronix.de>
 Oliver Upton <oliver.upton@linux.dev> <oupton@google.com>
 Ondřej Jirman <megi@xff.cz> <megous@megous.com>
 Oza Pawandeep <quic_poza@quicinc.com> <poza@codeaurora.org>
_

Patches currently in -mm which might be from o.rempel@pengutronix.de are

mailmap-correct-email-aliasing-for-oleksij-rempel.patch

