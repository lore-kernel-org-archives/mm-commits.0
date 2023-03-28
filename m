Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDC4C77B6F
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 22:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjC1WZX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 18:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjC1WZV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 18:25:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2FAE6
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 15:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28EBC619B3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 22:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83582C4339B;
        Tue, 28 Mar 2023 22:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680042317;
        bh=eba/vl7vnLG7w4YDv1TOH41nXPNObptvZA8nUZgc4co=;
        h=Date:To:From:Subject:From;
        b=yULqtLLyeeTx50tYY8c5Hf/YU5mPy9wvccDGB+Fxz2NOBVtSIkhrZGA3nucV4j8Qx
         PMmGpxyOV85La6qZNypt8na5cYcX5bnNtdodI6QCQiki4Ancaq5kawz7nFAeWVVHM1
         krUWS0bGtveyK0aom4ZsQ1hWttTF32+m3o/KRfnc=
Date:   Tue, 28 Mar 2023 15:25:17 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        stephen@networkplumber.org, qyousef@layalina.io, kuba@kernel.org,
        konrad.dybcio@linaro.org, colin.i.king@gmail.com,
        cdleonard@gmail.com, baolin.wang@linux.alibaba.com,
        f.fainelli@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-an-entry-for-leonard-crestez.patch removed from -mm tree
Message-Id: <20230328222517.83582C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add an entry for Leonard Crestez
has been removed from the -mm tree.  Its filename was
     mailmap-add-an-entry-for-leonard-crestez.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: mailmap: add an entry for Leonard Crestez
Date: Fri, 24 Mar 2023 06:07:36 -0700

Link: https://lkml.kernel.org/r/20230324130737.3360169-1-f.fainelli@gmail.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-an-entry-for-leonard-crestez
+++ a/.mailmap
@@ -265,6 +265,7 @@ Krzysztof Kozlowski <krzk@kernel.org> <k
 Krzysztof Kozlowski <krzk@kernel.org> <krzysztof.kozlowski@canonical.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Kuogee Hsieh <quic_khsieh@quicinc.com> <khsieh@codeaurora.org>
+Leonard Crestez <leonard.crestez@nxp.com> Leonard Crestez <cdleonard@gmail.com>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
 Leonard Göhrs <l.goehrs@pengutronix.de>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

scripts-gdb-bail-early-if-there-are-no-clocks.patch
scripts-gdb-bail-early-if-there-are-no-generic-pd.patch
scripts-gdb-bail-early-if-there-are-no-generic-pd-v2.patch

