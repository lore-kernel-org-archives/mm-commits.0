Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8351FEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 22:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjGBWY2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 18:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBWY2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 18:24:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BA1100
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 15:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE76960CE8
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 22:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35485C433C7;
        Sun,  2 Jul 2023 22:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688336666;
        bh=lR1x2Rw79XHZLEVNS47ryca/yUIOl8GScZnWHGJPQ3o=;
        h=Date:To:From:Subject:From;
        b=pUxo7Ayfsz2Nf1W7hwxXMlIyzi/b7rK1aUQ76S0W7wVV1hj0apQRZdidMyIP61C9B
         8dMsHKdQA9DZVJb1pk/9HARVJBVFqbVpHltIe7jjl15Fg2zrJ4pBMjUKwKlekPNSWp
         bHJAnEaX1+Sl4CNA90CYAS7lf7Q1yX5t9Be+Iq9s=
Date:   Sun, 02 Jul 2023 15:24:25 -0700
To:     mm-commits@vger.kernel.org, msp@baylibre.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-markus-schneider-pargmann.patch added to mm-hotfixes-unstable branch
Message-Id: <20230702222426.35485C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add Markus Schneider-Pargmann
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-markus-schneider-pargmann.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-markus-schneider-pargmann.patch

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
From: Markus Schneider-Pargmann <msp@baylibre.com>
Subject: mailmap: add Markus Schneider-Pargmann
Date: Wed, 28 Jun 2023 10:13:41 +0200

Add my old mail address and update my name.

Link: https://lkml.kernel.org/r/20230628081341.3470229-1-msp@baylibre.com
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-markus-schneider-pargmann
+++ a/.mailmap
@@ -301,6 +301,7 @@ Marek Behún <kabel@kernel.org> <marek.b
 Marek Behún <kabel@kernel.org> Marek Behun <marek.behun@nic.cz>
 Mark Brown <broonie@sirena.org.uk>
 Mark Starovoytov <mstarovo@pm.me> <mstarovoitov@marvell.com>
+Markus Schneider-Pargmann <msp@baylibre.com> <mpa@pengutronix.de>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@ginzinger.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
_

Patches currently in -mm which might be from msp@baylibre.com are

mailmap-add-markus-schneider-pargmann.patch

