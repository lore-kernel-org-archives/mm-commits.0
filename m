Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07E4CD68E3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 00:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379328AbjJJAvz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 20:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379320AbjJJAvw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 20:51:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD0DE0
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 17:51:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918A9C433CD;
        Tue, 10 Oct 2023 00:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696899110;
        bh=+Cbw1aU8RrG9Iy4yJss7H7lLOiHTHLJgJKkvC5GslAA=;
        h=Date:To:From:Subject:From;
        b=aUm/Ukwub5Ew6jesCBw8mToytlgVUQ/51CbtcnEl1tib1dyPCTbWh6y4MzdwT3nmO
         61oK34sQo3tCdTo1kz2CAEkummV8mfmCMZsWf6Qy7FJlHMhFsH+ZUQkwxlHolXw2eC
         rdePwK53Cbf5jjOnUsGsO0mR5/EonYWzddY6tZnc=
Date:   Mon, 09 Oct 2023 17:51:32 -0700
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        qyousef@layalina.io, quic_bjorande@quicinc.com, kuba@kernel.org,
        konrad.dybcio@linaro.org, heiko@sntech.de, broonie@kernel.org,
        axboe@kernel.dk, megi@xff.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-my-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20231010005147.918A9C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Ondrej has moved
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-my-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-my-email-address.patch

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
From: Ondrej Jirman <megi@xff.cz>
Subject: MAINTAINERS: Ondrej has moved
Date: Sun, 8 Oct 2023 12:58:07 +0200

Update my email-address in MAINTAINERS to <megi@xff.cz>.  Also add
.mailmap entries to map my old, now blocked, email address.

Link: https://lkml.kernel.org/r/20231008105812.1084226-1-megi@xff.cz
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org> # qcom
Cc: Mark Brown <broonie@kernel.org>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-my-email-address
+++ a/.mailmap
@@ -452,6 +452,7 @@ Oleksij Rempel <linux@rempel-privat.de>
 Oleksij Rempel <linux@rempel-privat.de> <o.rempel@pengutronix.de>
 Oleksij Rempel <linux@rempel-privat.de> <ore@pengutronix.de>
 Oliver Upton <oliver.upton@linux.dev> <oupton@google.com>
+Ondřej Jirman <megi@xff.cz> <megous@megous.com>
 Oza Pawandeep <quic_poza@quicinc.com> <poza@codeaurora.org>
 Pali Rohár <pali@kernel.org> <pali.rohar@gmail.com>
 Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
--- a/MAINTAINERS~maintainers-update-my-email-address
+++ a/MAINTAINERS
@@ -6748,7 +6748,7 @@ F:	drivers/gpu/drm/panel/panel-sitronix-
 DRM DRIVER FOR SITRONIX ST7703 PANELS
 M:	Guido Günther <agx@sigxcpu.org>
 R:	Purism Kernel Team <kernel@puri.sm>
-R:	Ondrej Jirman <megous@megous.com>
+R:	Ondrej Jirman <megi@xff.cz>
 S:	Maintained
 F:	Documentation/devicetree/bindings/display/panel/rocktech,jh057n00900.yaml
 F:	drivers/gpu/drm/panel/panel-sitronix-st7703.c
_

Patches currently in -mm which might be from megi@xff.cz are

maintainers-update-my-email-address.patch

