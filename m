Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4664C6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 19:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCMTjw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 15:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCMTjr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 15:39:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B5B7F013
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 12:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69477B81150
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 19:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29700C433D2;
        Mon, 13 Mar 2023 19:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678736383;
        bh=0q1I/1RXDs8f8n9os/z3IYned+hUeHBTHWN26QwVtzE=;
        h=Date:To:From:Subject:From;
        b=UdH34tBjjRw2rRBg7dMjjwyh3ozlr14PVokF3RF03daxRt3qnCW4vaLfSTVhaFLx1
         Iq00iA9ZRTpZllPVc8gMK/FysFBgFLERellbkhxTovOp9ys0Oxve/bsBsQLHNf0mWt
         X4aZKHQu0CnDAvdXRduv+VSd288u7J6/2E/HkbwY=
Date:   Mon, 13 Mar 2023 12:39:42 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        stephen@networkplumber.org, qyousef@layalina.io,
        quic_rjendra@quicinc.com, marijn.suijten@somainline.org,
        kuba@kernel.org, colin.i.king@gmail.com,
        baolin.wang@linux.alibaba.com, andersson@kernel.org,
        agross@kernel.org, konrad.dybcio@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-rajendra-nayaks-old-address-to-his-current-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20230313193943.29700C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: map Rajendra Nayak's old address to his current one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-rajendra-nayaks-old-address-to-his-current-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-rajendra-nayaks-old-address-to-his-current-one.patch

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
Subject: mailmap: map Rajendra Nayak's old address to his current one
Date: Mon, 13 Mar 2023 10:03:43 +0100

Rajendra's old email is still picked up by the likes of get_maintainer.pl
and keeps bouncing like all other @codeaurora.org addresses.  Map it to
his current one.

Link: https://lkml.kernel.org/r/20230313090343.2148346-1-konrad.dybcio@linaro.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Rajendra Nayak <quic_rjendra@quicinc.com>
Cc: Andy Gross <agross@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Marijn Suijten <marijn.suijten@somainline.org>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-map-rajendra-nayaks-old-address-to-his-current-one
+++ a/.mailmap
@@ -371,6 +371,7 @@ Quentin Monnet <quentin@isovalent.com> <
 Quentin Perret <qperret@qperret.net> <quentin.perret@arm.com>
 Rafael J. Wysocki <rjw@rjwysocki.net> <rjw@sisk.pl>
 Rajeev Nandan <quic_rajeevny@quicinc.com> <rajeevny@codeaurora.org>
+Rajendra Nayak <quic_rjendra@quicinc.com> <rnayak@codeaurora.org>
 Rajesh Shah <rajesh.shah@intel.com>
 Ralf Baechle <ralf@linux-mips.org>
 Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
_

Patches currently in -mm which might be from konrad.dybcio@linaro.org are

mailmap-map-rajendra-nayaks-old-address-to-his-current-one.patch

