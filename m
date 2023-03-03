Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65153C7EE3A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 05:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCCFzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCCFzm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 00:55:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012631E1EA
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 21:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869A461734
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 05:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EBDC4339C;
        Fri,  3 Mar 2023 05:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822905;
        bh=NVu4UDEN4S5hLp7Mx/iKVLpDUjfqc/CoqrgwON0SQCQ=;
        h=Date:To:From:Subject:From;
        b=rjxmrqyYYp37DQesKcKcBBK/jL09ckQiJ0ZHVmzl/OjYZLU7wnKKvqXnHBvyCh/xj
         bYMHlhVpZ9ku20Tfir8rjhmKIY2n0e5jIVD3wE0ctxiR0VF/JbnpZsq5f7qdHBBdly
         E4aR5xHSOXsAqc94CYNShhcGZeF4+UzTOINGj8PY=
Date:   Thu, 02 Mar 2023 21:55:04 -0800
To:     mm-commits@vger.kernel.org, quic_vgarodia@quicinc.com,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-vikash-garodias-old-address-to-his-current-one.patch removed from -mm tree
Message-Id: <20230303055504.D9EBDC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: map Vikash Garodia's old address to his current one
has been removed from the -mm tree.  Its filename was
     mailmap-map-vikash-garodias-old-address-to-his-current-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


--- a/.mailmap~mailmap-map-vikash-garodias-old-address-to-his-current-one
+++ a/.mailmap
@@ -442,6 +442,7 @@ Vasily Averin <vasily.averin@linux.dev>
 Vasily Averin <vasily.averin@linux.dev> <vvs@parallels.com>
 Vasily Averin <vasily.averin@linux.dev> <vvs@sw.ru>
 Valentin Schneider <vschneid@redhat.com> <valentin.schneider@arm.com>
+Vikash Garodia <quic_vgarodia@quicinc.com> <vgarodia@codeaurora.org>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@intel.com>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@linux.intel.com>
 Vinod Koul <vkoul@kernel.org> <vkoul@infradead.org>
_

Patches currently in -mm which might be from konrad.dybcio@linaro.org are

mailmap-correct-dikshita-agarwals-qualcomm-email-address.patch

