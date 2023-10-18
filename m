Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22893CDB488
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 19:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjJRTN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjJRTNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 15:13:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DF12F
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 12:13:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CED2C433C8;
        Wed, 18 Oct 2023 19:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697656401;
        bh=Z2htAmCTbWWu9UevEbYQbqlURbA0F799vx40gPHc1fw=;
        h=Date:To:From:Subject:From;
        b=lZDGtLCCa5uicyDQdOUOVvmivdVZ6CHqwlnQVK3Awq2iGYLrX3+PCfrUpVA4VNn2o
         u/D9scvbbivBUnZOvbcZ0vHEKTxZh7HKnyI++Oyxz+ILvjcGFkhbhZeCwS5Nmv+aoW
         zTYGt/+PNWVuyLNG8kWYL4bmueCW9brPvAo15uWA=
Date:   Wed, 18 Oct 2023 12:13:20 -0700
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        qyousef@layalina.io, quic_bjorande@quicinc.com, kuba@kernel.org,
        konrad.dybcio@linaro.org, heiko@sntech.de, conor@kernel.org,
        axboe@kernel.dk, bartosz.golaszewski@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-my-old-address-to-the-current-one.patch removed from -mm tree
Message-Id: <20231018191321.2CED2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: map Bartosz's old address to the current one
has been removed from the -mm tree.  Its filename was
     mailmap-map-my-old-address-to-the-current-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: mailmap: map Bartosz's old address to the current one
Date: Wed, 11 Oct 2023 17:01:04 +0200

I no longer work for BayLibre but many DT bindings have my BL address in
the maintainers entries.  Map it to the email address I use for kernel
development.

Link: https://lkml.kernel.org/r/20231011150104.73863-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Suggested-by: Conor Dooley <conor@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org> # qcom
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-map-my-old-address-to-the-current-one
+++ a/.mailmap
@@ -87,6 +87,7 @@ Baolin Wang <baolin.wang@linux.alibaba.c
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang7@gmail.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
+Bartosz Golaszewski <brgl@bgdev.pl> <bgolaszewski@baylibre.com>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@simtec.co.uk>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@sifive.com>
 Ben Gardner <bgardner@wabtec.com>
_

Patches currently in -mm which might be from bartosz.golaszewski@linaro.org are


