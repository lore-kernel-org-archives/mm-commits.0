Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18DAECAAD4
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 02:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiH0Cj7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 22:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiH0Cj6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 22:39:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BAB1CB0D
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 19:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50AEB61DA7
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 02:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0488C433B5;
        Sat, 27 Aug 2022 02:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661567994;
        bh=Q69JUqFyyyBEzq96m/AKPOdjp7TtSMXx8nYE28QwEE0=;
        h=Date:To:From:Subject:From;
        b=yHmDODVGhwFP4WLEm3XSMvZSUpngxMeYzeZkVqDLsm7tRVzvT6SZbSWjD1HzBd5tg
         5mAyx0j8AH6iKiZueQUUWaY6WO7kOEevqXYx8SuUl+8TEwRMdYqI/WpDlDefs5KOMs
         vXxriUqBdrVXoSa0lu88ByAZWc6RipXIK4AFOYAs=
Date:   Fri, 26 Aug 2022 19:39:53 -0700
To:     mm-commits@vger.kernel.org, thomas.petazzoni@bootlin.com,
        hverkuil-cisco@xs4all.nl, atishp@atishpatra.org, arnd@arndb.de,
        luca.ceresoli@bootlin.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-luca-ceresolis-e-mail-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20220827023954.A0488C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: update Luca Ceresoli's e-mail address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-luca-ceresolis-e-mail-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-luca-ceresolis-e-mail-address.patch

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
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: .mailmap: update Luca Ceresoli's e-mail address
Date: Fri, 26 Aug 2022 15:05:15 +0200

My Bootlin address is preferred from now on.

Link: https://lkml.kernel.org/r/20220826130515.3011951-1-luca.ceresoli@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-luca-ceresolis-e-mail-address
+++ a/.mailmap
@@ -254,6 +254,7 @@ Linus Lüssing <linus.luessing@c0d3.blue
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
+Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Maciej W. Rozycki <macro@mips.com> <macro@imgtec.com>
 Maciej W. Rozycki <macro@orcam.me.uk> <macro@linux-mips.org>
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are

mailmap-update-luca-ceresolis-e-mail-address.patch

