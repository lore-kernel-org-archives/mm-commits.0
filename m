Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98E9C6FA99
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 01:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCHBFh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 20:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjCHBFe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 20:05:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3EA5A6D4
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 17:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 805F8B819F3
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 01:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30933C433EF;
        Wed,  8 Mar 2023 01:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237530;
        bh=3bgqdV0UNSRT5LwRvEQwoR17LNgpKM7dgy+4XTiG2WM=;
        h=Date:To:From:Subject:From;
        b=S6cVy//pa/KNOhk2Yt0la/GOJiDIL2UnN33K32uHH05x1TeM0nzRktNtdvYWkWhT5
         Oz1yjjfVxWYUzvOkbvfkXu8I2uQwQVqdzLI355NfQsOxdd6uNSQLuCX13coU65XW/R
         h3sFMa0a7iS7qbTFWhHTHs9FKQ1Jpe/Gh8K1hixw=
Date:   Tue, 07 Mar 2023 17:05:29 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, quic_dikshita@quicinc.com,
        marijn.suijten@somainline.org, colin.i.king@gmail.com,
        baolin.wang@linux.alibaba.com, arnd@arndb.de, andersson@kernel.org,
        agross@kernel.org, konrad.dybcio@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch removed from -mm tree
Message-Id: <20230308010530.30933C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: correct Dikshita Agarwal's Qualcomm email address
has been removed from the -mm tree.  Its filename was
     mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


