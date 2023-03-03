Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA941C64EC4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 05:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjCCF4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCCFzo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 00:55:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9811CAC0
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 21:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47C94B816A2
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 05:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1028C433D2;
        Fri,  3 Mar 2023 05:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822906;
        bh=H17GYhYzXyHT+tuScH9uFFi2SbqnZEovtx6l+dQupkY=;
        h=Date:To:From:Subject:From;
        b=eHp5L/LuxIJ5VD+8tUJZ4A5N6MWLhrYnMmP2O+2l18DrWeRiJgtOLA3ARf2R+1jyc
         iPB7OaJhWyjAUylMgTMzGnomjwjbA7WaV0AnXRa/R9m9ed4tmpSPtJMeyAto6tyft+
         YNdltRHAnA46FXleAMFS0w7U3PMp6fGFuN8oEx3w=
Date:   Thu, 02 Mar 2023 21:55:05 -0800
To:     mm-commits@vger.kernel.org, dikshita@qti.qualcomm.com,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch removed from -mm tree
Message-Id: <20230303055505.E1028C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: map Dikshita Agarwal's old address to his current one
has been removed from the -mm tree.  Its filename was
     mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch

