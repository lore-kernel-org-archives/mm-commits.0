Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CE2C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 22:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjC1WZL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 18:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjC1WZK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 18:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A44BE6
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 15:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99C261994
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 22:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442B0C433EF;
        Tue, 28 Mar 2023 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680042308;
        bh=gMSFrfPguqB0VkjXaM1AT0yFZCbjhxAcWP7RvcXUC0g=;
        h=Date:To:From:Subject:From;
        b=KYiBzmdK9qUFI0GNNA3hF/yvCSDBBIr7i7RZFfSO2Tv4jPK9JB0/Kqv0geUgBEdZS
         PquU1Cu7G5/j/KTgw/0ADqMf0u8jN5GBVkOam8iShmnUXbn9Rp/0+t0Oa4ajTw0bVQ
         HIrAioOHQkhPgH5uf7mJEKyRE/3MhAhMFChctwjA=
Date:   Tue, 28 Mar 2023 15:25:07 -0700
To:     mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        l.goehrs@pengutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-leonard-gohrs.patch removed from -mm tree
Message-Id: <20230328222508.442B0C433EF@smtp.kernel.org>
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
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-leonard-gohrs
+++ a/.mailmap
@@ -266,6 +266,7 @@ Krzysztof Kozlowski <krzk@kernel.org> <k
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Kuogee Hsieh <quic_khsieh@quicinc.com> <khsieh@codeaurora.org>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
+Leonard Göhrs <l.goehrs@pengutronix.de>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
 Leon Romanovsky <leon@kernel.org> <leon@leon.nu>
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
_

Patches currently in -mm which might be from l.goehrs@pengutronix.de are


