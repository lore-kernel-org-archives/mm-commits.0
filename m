Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291AFC64EC4
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 20:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjB1UYY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Feb 2023 15:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjB1UYW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2023 15:24:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4A530293
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 12:24:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 15F57CE1ABA
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 20:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72803C433D2;
        Tue, 28 Feb 2023 20:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677615854;
        bh=OLs4tkaA3t3zCE9ORBmwFXSbpwclqdX1Yk+O8HZ7CYQ=;
        h=Date:To:From:Subject:From;
        b=0qZvRKtgNIh83otWJP953Id/EXPKdUo7lNoyqluDEg8WM/Vv6orWeG5SpC7jFb29Y
         vY7uInoEVqUfOIe6X1dSH1UvivZUGTajV6GeZrRocVfBSOBq77xPfWO8MUkkM40rQ3
         HWlL2svjMuv4tXwCpHw0Fc/7v0j0f2AHwE/xD+Ho=
Date:   Tue, 28 Feb 2023 12:24:14 -0800
To:     mm-commits@vger.kernel.org, dikshita@qti.qualcomm.com,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20230228202414.72803C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: map Dikshita Agarwal's old address to his current one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch

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
Subject: mailmap: map Dikshita Agarwal's old address to his current one
Date: Tue, 28 Feb 2023 16:33:34 +0100

Dikshita's old email is still picked up by the likes of get_maintainer.pl
and keeps bouncing.  Map it to his current one.

Link: https://lkml.kernel.org/r/20230228153335.907164-2-konrad.dybcio@linaro.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Dikshita Agarwal <dikshita@qti.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-map-dikshita-agarwals-old-address-to-his-current-one
+++ a/.mailmap
@@ -121,6 +121,7 @@ Dengcheng Zhu <dzhu@wavecomp.com> <dengc
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@imgtec.com>
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@mips.com>
 <dev.kurt@vandijck-laurijssen.be> <kurt.van.dijck@eia.be>
+Dikshita Agarwal <dikshita@qti.qualcomm.com> <dikshita@codeaurora.org>
 Dmitry Baryshkov <dbaryshkov@gmail.com>
 Dmitry Baryshkov <dbaryshkov@gmail.com> <[dbaryshkov@gmail.com]>
 Dmitry Baryshkov <dbaryshkov@gmail.com> <dmitry_baryshkov@mentor.com>
_

Patches currently in -mm which might be from konrad.dybcio@linaro.org are

mailmap-map-vikash-garodias-old-address-to-his-current-one.patch
mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch

