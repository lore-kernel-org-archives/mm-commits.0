Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4071DC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbiKWCxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiKWCxY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9E68DA41
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06311B81E5F
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EE5C433D6;
        Wed, 23 Nov 2022 02:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172001;
        bh=ZuTYwAmg8ELe+5Jy3l70mvNbiycA3s1wQ8TwTy0SFas=;
        h=Date:To:From:Subject:From;
        b=ZYYg1ajYomgvK2UTjejuy6yG2KNydZM6+90sA/M+cdfiJrx0BgOHhQe28J5IoBDQi
         ZBMwpq5RXagBlYnd1v3Lq1TqagFNgLy0J1gCvaSEONEDuhUO4DJYUM6Zwd89Qd0362
         JF4HvHvX54oPs/03w+Ywz18qtYEy7DczHl96o3wI=
Date:   Tue, 22 Nov 2022 18:53:21 -0800
To:     mm-commits@vger.kernel.org, konrad.dybcio@linaro.org,
        quic_c_skakit@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-email-address-for-satya-priya.patch removed from -mm tree
Message-Id: <20221123025321.B8EE5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update email address for Satya Priya
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-satya-priya.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Satya Priya <quic_c_skakit@quicinc.com>
Subject: mailmap: update email address for Satya Priya
Date: Wed, 16 Nov 2022 16:20:17 +0530

Add and also update email address, skakit@codeaurora.org is no longer
active.

Link: https://lkml.kernel.org/r/20221116105017.3018971-1-quic_c_skakit@quicinc.com
Signed-off-by: Satya Priya <quic_c_skakit@quicinc.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-satya-priya
+++ a/.mailmap
@@ -383,6 +383,7 @@ Santosh Shilimkar <santosh.shilimkar@ora
 Santosh Shilimkar <ssantosh@kernel.org>
 Sarangdhar Joshi <spjoshi@codeaurora.org>
 Sascha Hauer <s.hauer@pengutronix.de>
+Satya Priya <quic_c_skakit@quicinc.com> <skakit@codeaurora.org>
 S.Çağlar Onur <caglar@pardus.org.tr>
 Sean Christopherson <seanjc@google.com> <sean.j.christopherson@intel.com>
 Sean Nyekjaer <sean@geanix.com> <sean.nyekjaer@prevas.dk>
_

Patches currently in -mm which might be from quic_c_skakit@quicinc.com are


