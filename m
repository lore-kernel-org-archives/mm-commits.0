Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5D4C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCWBdb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCWBd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351DD1700
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD287CE1F90
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF15C4339C;
        Thu, 23 Mar 2023 01:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535142;
        bh=ZsnR/RC+S0gGcGreYFtX52ZKW/sY08XDkJ95ItCsb1w=;
        h=Date:To:From:Subject:From;
        b=W/Hq4gvn7RF5Aou6lXjAZJdkuwrLNfmSeCImZcf1Pqx+DRIqW2eKZokb/4kjuAn8d
         giedrDV4aFlpA5qLMUe7srIuJSzxcXsTlIw05yFvpXWqtmJxjB9udryLIO49rlyan2
         vVAOOpU5uqgxHDE1+DipWcXEfl/671r4N4TtIAh8=
Date:   Wed, 22 Mar 2023 18:32:21 -0700
To:     mm-commits@vger.kernel.org, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-sai-prakash-ranjans-old-address-to-his-current-one.patch removed from -mm tree
Message-Id: <20230323013222.1DF15C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: map Sai Prakash Ranjan's old address to his current one
has been removed from the -mm tree.  Its filename was
     mailmap-map-sai-prakash-ranjans-old-address-to-his-current-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


