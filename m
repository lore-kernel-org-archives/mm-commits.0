Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE54C6FD1F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCWBeI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCWBdf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9ECCA25
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AC3DB81EB7
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E68EC433EF;
        Thu, 23 Mar 2023 01:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535141;
        bh=Lq9CV/ENIgxHPAGrEpESxZsLIXrK5N/NYx+62H76/GU=;
        h=Date:To:From:Subject:From;
        b=LK6iuDEr9ajkSqPZjrzg4eQHup4MlDVLbrd/trl66Y45NHAjnccvjrJY1WD5eejXW
         GaPBgK68hFmZHVSL2rhbvZmrIjx+youkcguBIq76y09KC7E7EMs6R1BRP3qmSaUO9u
         LBI1YJkXSzk9SdEt0E6LiuTeAXfntJGhtN9nwCiM=
Date:   Wed, 22 Mar 2023 18:32:20 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        stephen@networkplumber.org, qyousef@layalina.io,
        quic_rjendra@quicinc.com, marijn.suijten@somainline.org,
        kuba@kernel.org, colin.i.king@gmail.com,
        baolin.wang@linux.alibaba.com, andersson@kernel.org,
        agross@kernel.org, konrad.dybcio@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-rajendra-nayaks-old-address-to-his-current-one.patch removed from -mm tree
Message-Id: <20230323013221.1E68EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: map Rajendra Nayak's old address to his current one
has been removed from the -mm tree.  Its filename was
     mailmap-map-rajendra-nayaks-old-address-to-his-current-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


