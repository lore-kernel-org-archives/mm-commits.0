Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4440BC6FD1C
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 19:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCXThp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCXTho (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 15:37:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958D36585
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 12:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BEF962C79
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 19:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7280AC4339B;
        Fri, 24 Mar 2023 19:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679686662;
        bh=G3id/FxUuucHDtITS8hqdak6RfgScTSpUvKRt9XPc7A=;
        h=Date:To:From:Subject:From;
        b=ftI/k+AKoPk0rasRumaQVe89zw9sGG0NNtQUZOXXboVgLezIaSU2P2YHtxkyRU3Hy
         LqaNGP2qrQoLD5UPuhgUNrMb7UntS4h2NB0sYwqynBmux/BCvwSElRfKxqXYGPp4F4
         WAUJDkGszM7/p8PJlQdtoCDclLJIWhRl9GckCve8=
Date:   Fri, 24 Mar 2023 12:37:41 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        stephen@networkplumber.org, qyousef@layalina.io, kuba@kernel.org,
        konrad.dybcio@linaro.org, colin.i.king@gmail.com,
        cdleonard@gmail.com, baolin.wang@linux.alibaba.com,
        f.fainelli@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-an-entry-for-leonard-crestez.patch added to mm-hotfixes-unstable branch
Message-Id: <20230324193742.7280AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add an entry for Leonard Crestez
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-an-entry-for-leonard-crestez.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-an-entry-for-leonard-crestez.patch

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
@@ -257,6 +257,7 @@ Krzysztof Kozlowski <krzk@kernel.org> <k
 Krzysztof Kozlowski <krzk@kernel.org> <krzysztof.kozlowski@canonical.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Kuogee Hsieh <quic_khsieh@quicinc.com> <khsieh@codeaurora.org>
+Leonard Crestez <leonard.crestez@nxp.com> Leonard Crestez <cdleonard@gmail.com>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
 Leonard Göhrs <l.goehrs@pengutronix.de>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

mailmap-add-an-entry-for-leonard-crestez.patch

