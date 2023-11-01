Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60387C001B0
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347405AbjKATrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348064AbjKATrk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBEC119
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFA7C433CC;
        Wed,  1 Nov 2023 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868054;
        bh=8bjapzg4WzkNyAG2/LhMned+4opAURSvC1B16SSDPSs=;
        h=Date:To:From:Subject:From;
        b=YSqQJRfR71zJU+DGQaoWTnzH7kYaNBBWZvHuPnl+mvlzwIXKU/eecaqa1a9+PBUWG
         n3FJmmSvV+49fzck1TOJdg8zpu5fAVlLjMSeGpN3Cn9z+99E9b4+Ecf08lbtL+1ZkW
         zBEAnR+eKvL0BADEwY+9HCoWmRdLI6i8W8F/RKPA=
Date:   Wed, 01 Nov 2023 12:47:33 -0700
To:     mm-commits@vger.kernel.org, quic_bjorande@quicinc.com,
        o.rempel@pengutronix.de, kuba@kernel.org, konrad.dybcio@linaro.org,
        heiko@sntech.de, axboe@kernel.dk, claudiu.beznea@tuxon.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-email-address-for-claudiu-beznea.patch removed from -mm tree
Message-Id: <20231101194734.3BFA7C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update email address for Claudiu Beznea
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-claudiu-beznea.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -128,6 +128,7 @@ Christian Brauner <brauner@kernel.org> <
 Christian Marangi <ansuelsmth@gmail.com>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
+Claudiu Beznea <claudiu.beznea@tuxon.dev> <claudiu.beznea@microchip.com>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
_

Patches currently in -mm which might be from claudiu.beznea@tuxon.dev are


