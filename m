Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA101C6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCCC0j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCCC0i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:26:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760F5457F9
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:26:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E6766170E
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76939C433EF;
        Fri,  3 Mar 2023 02:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677810396;
        bh=TDMA0FOwydi3tGUDYXuj61Rha19r2M62IWX3ZFoasK0=;
        h=Date:To:From:Subject:From;
        b=mjVH3unSgID8UWY0S0PUznZYpmktdGgwghJLqpYWFV/+PSEsBKOioh+IKqlF03sU0
         7/da+HqW7Qj0irLdPqE3a8yiFuNKjaPKZZUpLTO7N4O3TYTBPcdKC473iOF0LTtsa2
         ZzkVQljm9tjHkX6EdKvbNUoPn2VQhtXg3DfvP9k8=
Date:   Thu, 02 Mar 2023 18:26:35 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, quic_dikshita@quicinc.com,
        marijn.suijten@somainline.org, colin.i.king@gmail.com,
        baolin.wang@linux.alibaba.com, arnd@arndb.de, andersson@kernel.org,
        agross@kernel.org, konrad.dybcio@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20230303022636.76939C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: correct Dikshita Agarwal's Qualcomm email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch

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
Subject: mailmap: correct Dikshita Agarwal's Qualcomm email address
Date: Wed, 1 Mar 2023 12:00:12 +0100

I recently sent a patch to map Dikshita's old CAF address to his current
one @ Qualcomm.  It turned out however, that he has two of them, with the
@quicinc.com one meant for upstream contributions.  Fix it.

Link: https://lkml.kernel.org/r/20230301110012.1290379-1-konrad.dybcio@linaro.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Dikshita Agarwal <quic_dikshita@quicinc.com>
Cc: Andy Gross <agross@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Marijn Suijten <marijn.suijten@somainline.org>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-correct-dikshita-agarwals-qualcomm-email-address
+++ a/.mailmap
@@ -121,7 +121,7 @@ Dengcheng Zhu <dzhu@wavecomp.com> <dengc
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@imgtec.com>
 Dengcheng Zhu <dzhu@wavecomp.com> <dengcheng.zhu@mips.com>
 <dev.kurt@vandijck-laurijssen.be> <kurt.van.dijck@eia.be>
-Dikshita Agarwal <dikshita@qti.qualcomm.com> <dikshita@codeaurora.org>
+Dikshita Agarwal <quic_dikshita@quicinc.com> <dikshita@codeaurora.org>
 Dmitry Baryshkov <dbaryshkov@gmail.com>
 Dmitry Baryshkov <dbaryshkov@gmail.com> <[dbaryshkov@gmail.com]>
 Dmitry Baryshkov <dbaryshkov@gmail.com> <dmitry_baryshkov@mentor.com>
_

Patches currently in -mm which might be from konrad.dybcio@linaro.org are

mailmap-map-vikash-garodias-old-address-to-his-current-one.patch
mailmap-map-dikshita-agarwals-old-address-to-his-current-one.patch
mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch

