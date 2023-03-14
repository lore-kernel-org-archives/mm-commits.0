Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD002C7618B
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCNVgL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjCNVgK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:36:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1330515D8
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:36:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A84F6B819ED
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528ABC433D2;
        Tue, 14 Mar 2023 21:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678829764;
        bh=Cbvwx8Ms7FhJZFFRHdmUhpMQLA0LbhZfBh+7WRLziyc=;
        h=Date:To:From:Subject:From;
        b=rs3tL3m6LXrNcxlQdgU4rNOUElOvhHrCuE3Rj5/memM48jJBGuJpjGrzV1/aFyigI
         RBV/iqBG8EHKMM3O9ZjUjYDtLLtQrtSzvgn5mzsQS40gRJlgi/lgsU8UxprUIZx7Nj
         keEJSqR9qeMVIrRgbNu+hW6A1Xq1wUEjonzzSs3U=
Date:   Tue, 14 Mar 2023 14:36:03 -0700
To:     mm-commits@vger.kernel.org, eballetbo@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-enric-balletbo-i-serra.patch added to mm-hotfixes-unstable branch
Message-Id: <20230314213604.528ABC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Enric Balletbo i Serra
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-enric-balletbo-i-serra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-enric-balletbo-i-serra.patch

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
From: Enric Balletbo i Serra <eballetbo@kernel.org>
Subject: mailmap: add entry for Enric Balletbo i Serra
Date: Tue, 14 Mar 2023 12:54:55 +0100

Map Enric's old corporate addresses to his kernel.org address.

Link: https://lkml.kernel.org/r/20230314115455.188818-1-eballetbo@kernel.org
Signed-off-by: Enric Balletbo i Serra <eballetbo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-entry-for-enric-balletbo-i-serra
+++ a/.mailmap
@@ -133,6 +133,8 @@ Dmitry Safonov <0x7f454c46@gmail.com> <d
 Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
 Ed L. Cashin <ecashin@coraid.com>
+Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
+Enric Balletbo i Serra <eballetbo@kernel.org> <eballetbo@iseebcn.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
 Eugen Hristev <eugen.hristev@collabora.com> <eugen.hristev@microchip.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
_

Patches currently in -mm which might be from eballetbo@kernel.org are

mailmap-add-entry-for-enric-balletbo-i-serra.patch

