Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969E0C64EC7
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 20:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjB1UYS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Feb 2023 15:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjB1UYQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2023 15:24:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96BC3252E
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 12:24:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2985FB80E72
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 20:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C130EC433EF;
        Tue, 28 Feb 2023 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677615852;
        bh=oDryivAt+nPhSI36E0RNki88/yhn42MOZz5f2/O8G0U=;
        h=Date:To:From:Subject:From;
        b=jhKZHobffzw5k27yiNuBGqlOnnS0zJKbUZOmv6JXPoBXtDbXl+jJuGQGL+GicuRZl
         5rNnVfw2UiGKUlV8YTxdUegzJ2Diq8z2JHYr5+zedRlOg1uL3xBXsh/7k8zP3iNZNa
         bH9iG3Dz2UdAcwKQVUb7zV1LD76XhpzTjug9dpJU=
Date:   Tue, 28 Feb 2023 12:24:12 -0800
To:     mm-commits@vger.kernel.org, quic_vgarodia@quicinc.com,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-vikash-garodias-old-address-to-his-current-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20230228202412.C130EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: map Vikash Garodia's old address to his current one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-vikash-garodias-old-address-to-his-current-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-vikash-garodias-old-address-to-his-current-one.patch

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
From: Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: mailmap: map Vikash Garodia's old address to his current one
Date: Tue, 28 Feb 2023 16:33:35 +0100

Vikash's old email is still picked up by the likes of get_maintainer.pl
and keeps bouncing.  Map it to his current one.

Link: https://lkml.kernel.org/r/20230228153335.907164-3-konrad.dybcio@linaro.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-map-vikash-garodias-old-address-to-his-current-one
+++ a/.mailmap
@@ -441,6 +441,7 @@ Vasily Averin <vasily.averin@linux.dev>
 Vasily Averin <vasily.averin@linux.dev> <vvs@parallels.com>
 Vasily Averin <vasily.averin@linux.dev> <vvs@sw.ru>
 Valentin Schneider <vschneid@redhat.com> <valentin.schneider@arm.com>
+Vikash Garodia <quic_vgarodia@quicinc.com> <vgarodia@codeaurora.org>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@intel.com>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@linux.intel.com>
 Vinod Koul <vkoul@kernel.org> <vkoul@infradead.org>
_

Patches currently in -mm which might be from konrad.dybcio@linaro.org are

mailmap-map-vikash-garodias-old-address-to-his-current-one.patch
mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch

