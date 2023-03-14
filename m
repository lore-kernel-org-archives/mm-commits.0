Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C53C7618B
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCNVdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCNVdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:33:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7D920A2F
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB1D619CB
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE2EC433D2;
        Tue, 14 Mar 2023 21:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678829609;
        bh=wc5Yao7DgkqygS80/23PlHUMMQTCXq7cBlwxgPCQXD0=;
        h=Date:To:From:Subject:From;
        b=kD7Psr4qazCdFQeqO2/5r0S3BHBwf6CBJVhvnFi3vPqqOUWVHwo7XeZf7rn4YSKoF
         43PbXzEAT0oc48fKyZRHuPSRMFf+m3moACqSTV+bv7sm+XqoS/M2MmsW3zXFweugp5
         74gzVl3eDixE8Y6Nku5wJHVJZfRletqedf0Yy2uQ=
Date:   Tue, 14 Mar 2023 14:33:29 -0700
To:     mm-commits@vger.kernel.org, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-sai-prakash-ranjans-old-address-to-his-current-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20230314213329.BEE2EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: map Sai Prakash Ranjan's old address to his current one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-sai-prakash-ranjans-old-address-to-his-current-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-sai-prakash-ranjans-old-address-to-his-current-one.patch

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
Subject: mailmap: map Sai Prakash Ranjan's old address to his current one
Date: Tue, 14 Mar 2023 13:56:03 +0100

Sai's old email is still picked up by the likes of get_maintainer.pl and
keeps bouncing like all other @codeaurora.org addresses.  Map it to his
current one.

Link: https://lkml.kernel.org/r/20230314125604.2734146-1-konrad.dybcio@linaro.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-map-sai-prakash-ranjans-old-address-to-his-current-one
+++ a/.mailmap
@@ -390,6 +390,7 @@ Ross Zwisler <zwisler@kernel.org> <ross.
 Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
 Sachin P Sant <ssant@in.ibm.com>
+Sai Prakash Ranjan <quic_saipraka@quicinc.com> <saiprakash.ranjan@codeaurora.org>
 Sakari Ailus <sakari.ailus@linux.intel.com> <sakari.ailus@iki.fi>
 Sam Ravnborg <sam@mars.ravnborg.org>
 Sankeerth Billakanti <quic_sbillaka@quicinc.com> <sbillaka@codeaurora.org>
_

Patches currently in -mm which might be from konrad.dybcio@linaro.org are

mailmap-map-rajendra-nayaks-old-address-to-his-current-one.patch
mailmap-map-sai-prakash-ranjans-old-address-to-his-current-one.patch

