Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EF7C6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 19:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjCWTUC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 15:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWTUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 15:20:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F87EE2
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 12:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70976B81E21
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 19:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FD2C433D2;
        Thu, 23 Mar 2023 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679599198;
        bh=ZF/JIne+k7/tKLONT4O5JA062QXSsav6/V8OJRk7TzI=;
        h=Date:To:From:Subject:From;
        b=WiDAEHEU1IOpst5KXT1r3KnbzNrY3wWyNnMIJKqf4jfO/Sicb8MvkuctJGdEaKsRT
         myg7sEIqjly6n8rGisjyfuLYvR8QHssUH6LKK/tvn0XSvrQJs7/7AUYmsPucVUwYPO
         ba3Tiem6GVAc4zb2xNeydEAb0UwZ4hHAo2CJy5JI=
Date:   Thu, 23 Mar 2023 12:19:57 -0700
To:     mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        l.goehrs@pengutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-leonard-gohrs.patch added to mm-hotfixes-unstable branch
Message-Id: <20230323191958.04FD2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: add entry for Leonard Göhrs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-leonard-gohrs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-leonard-gohrs.patch

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


--- a/.mailmap~mailmap-add-entry-for-leonard-gohrs
+++ a/.mailmap
@@ -263,6 +263,7 @@ Krzysztof Kozlowski <krzk@kernel.org> <k
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Kuogee Hsieh <quic_khsieh@quicinc.com> <khsieh@codeaurora.org>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
+Leonard Göhrs <l.goehrs@pengutronix.de>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
 Leon Romanovsky <leon@kernel.org> <leon@leon.nu>
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
_

Patches currently in -mm which might be from l.goehrs@pengutronix.de are

mailmap-add-entry-for-leonard-gohrs.patch

