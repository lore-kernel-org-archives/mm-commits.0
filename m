Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 676DECDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 19:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjJRTNX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjJRTNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 15:13:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E53D129
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 12:13:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ADFC433CA;
        Wed, 18 Oct 2023 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697656399;
        bh=xVDwzB/8QC+caQLDeGb2zKUEWdz1uUOzA6122Xg4XHY=;
        h=Date:To:From:Subject:From;
        b=13a2cS5KEeuolo37cJRMdOzkUpguowNZUK35DjEGobyzOd7Cm/1ue1uU6hFSUTymL
         oy42LT3O4h+FmDj/yO8Uin1Y6GDCxIkQu1HkdaNrAQMbhfCH/CrxVIGRgeC4YiTQ1W
         lIcfx7P2IS55pEETQ3wXeU8tGb8P6NyDuu1bdylI=
Date:   Wed, 18 Oct 2023 12:13:18 -0700
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        qyousef@layalina.io, quic_bjorande@quicinc.com, kuba@kernel.org,
        konrad.dybcio@linaro.org, heiko@sntech.de, broonie@kernel.org,
        axboe@kernel.dk, megi@xff.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-my-email-address.patch removed from -mm tree
Message-Id: <20231018191319.68ADFC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: Ondrej has moved
has been removed from the -mm tree.  Its filename was
     maintainers-update-my-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


