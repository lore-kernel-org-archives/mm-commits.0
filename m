Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB49C77B73
	for <mm-commits@archiver.kernel.org>; Wed, 19 Apr 2023 19:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjDSTeu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Apr 2023 15:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjDSTer (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2023 15:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C86E85
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 12:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702D9641E3
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 19:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C122EC4339B;
        Wed, 19 Apr 2023 19:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681932883;
        bh=1o0CeK5C8djg7xEoSNfkKKgMO0vVmGRdazfYUmRCzg0=;
        h=Date:To:From:Subject:From;
        b=EoJC4Vde1V0/9W10Fx0Gx6Ks5+AuASzuiqw2VpW8BAXs65222vpx3aJFEvxCOdN6p
         19q1IJ/RbytbWqkVZBbP1GwN4KJRc/ZSG+FAaic0m8S2jvhymJIic/hr5SOBNupbOj
         V373rGvnUXXP1EqIym13cc/zqA4J671w4RfV3NKU=
Date:   Wed, 19 Apr 2023 12:34:43 -0700
To:     mm-commits@vger.kernel.org, kuba@kernel.org,
        konrad.dybcio@linaro.org, oleksandr@natalenko.name,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-myself.patch added to mm-nonmm-unstable branch
Message-Id: <20230419193443.C122EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Oleksandr
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entry-for-myself.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-myself.patch

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
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: mailmap: add entry for Oleksandr
Date: Wed, 19 Apr 2023 15:47:34 +0200

Map my corporate email to my personal one.

Link: https://lkml.kernel.org/r/20230419134734.454630-1-oleksandr@natalenko.name
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-myself
+++ a/.mailmap
@@ -358,6 +358,7 @@ Nicolas Pitre <nico@fluxnic.net> <nico@l
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.com>
 Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
+Oleksandr Natalenko <oleksandr@natalenko.name> <oleksandr@redhat.com>
 Oleksij Rempel <linux@rempel-privat.de> <bug-track@fisher-privat.net>
 Oleksij Rempel <linux@rempel-privat.de> <external.Oleksij.Rempel@de.bosch.com>
 Oleksij Rempel <linux@rempel-privat.de> <fixed-term.Oleksij.Rempel@de.bosch.com>
_

Patches currently in -mm which might be from oleksandr@natalenko.name are

mailmap-add-entry-for-myself.patch

