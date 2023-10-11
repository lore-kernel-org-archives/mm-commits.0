Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7A7CDB472
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjJKRxh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbjJKRxg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:53:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5816C6
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:53:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4449EC433CA;
        Wed, 11 Oct 2023 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697046814;
        bh=ik77lLFPqeIGDoSe4lal19c4tdUW75iMqdV9P965wr8=;
        h=Date:To:From:Subject:From;
        b=coMrnvds3UR/uzk+jofO47DR/dc3Tf36aUwE7XzZZOT+95gQPMa0j+FAqS/QjpQ5D
         20ocsjZb7gvmzZkrpLjAUgAdZE6jd3L8SwLGEQiqEdp5VQ5p45p4YPnt+018ahL0dV
         /G64XggVX51ixoeVuZ7Wvj3dxFA8xS0NOJM5VQgo=
Date:   Wed, 11 Oct 2023 10:53:21 -0700
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        qyousef@layalina.io, quic_bjorande@quicinc.com, kuba@kernel.org,
        konrad.dybcio@linaro.org, heiko@sntech.de, conor@kernel.org,
        axboe@kernel.dk, bartosz.golaszewski@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-my-old-address-to-the-current-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20231011175332.4449EC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: map Bartosz's old address to the current one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-my-old-address-to-the-current-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-my-old-address-to-the-current-one.patch

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

mailmap-map-my-old-address-to-the-current-one.patch

