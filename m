Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9B4CDB489
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 19:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjJRTN1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjJRTNX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 15:13:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B3A130
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 12:13:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1BC433CB;
        Wed, 18 Oct 2023 19:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697656402;
        bh=V3qBbaKhyCg6pmtwfO4rRb6Tax/A1NnR2WM9DPjzeL8=;
        h=Date:To:From:Subject:From;
        b=hDi4et+ecmcpR8i+FvcTBXJxrJo0QLwhUfi7gZzyYdtaljqYTVQf8cAoZId1HIiZg
         11D1q9445hWD4c0QugJ8i71prgFZHMJaZF72YhQAkaDKVL/sF1MYnd7fox38EJ4Ej4
         uDs+wuA1w1G7drmqWizsyAZ5bMo2k1gJSaX0kEAA=
Date:   Wed, 18 Oct 2023 12:13:21 -0700
To:     mm-commits@vger.kernel.org, qyousef@layalina.io, kuba@kernel.org,
        konrad.dybcio@linaro.org, broonie@kernel.org,
        o.rempel@pengutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-correct-email-aliasing-for-oleksij-rempel.patch removed from -mm tree
Message-Id: <20231018191322.15A1BC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: correct email aliasing for Oleksij Rempel
has been removed from the -mm tree.  Its filename was
     mailmap-correct-email-aliasing-for-oleksij-rempel.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


