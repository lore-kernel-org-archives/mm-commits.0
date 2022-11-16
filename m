Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF520C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiKPWIm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiKPWIh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:08:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7107FAE4A
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:08:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1708B61FF1
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA4BC433C1;
        Wed, 16 Nov 2022 22:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668636515;
        bh=fBqH7xaPDOoA/shxxeybOyjxd67zjw+vvVdKOuepnl8=;
        h=Date:To:From:Subject:From;
        b=O0Qb68SDpsooUObPzzLuQv0lpGTa16XqIO1uTAZm7HVs55dVuhPxKJnXr3GXkKuFH
         Sht9UMtgm8q/irUn/nTXOB+R5VVPXr+/h8JWE4Rw+l7HNUdTb472SxXtnx+WZos1uP
         v0mK4FNJ2pDBvuZRUDauivkxvOtDUMeVZYl8fGuw=
Date:   Wed, 16 Nov 2022 14:08:34 -0800
To:     mm-commits@vger.kernel.org, konrad.dybcio@linaro.org,
        quic_c_skakit@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-satya-priya.patch added to mm-hotfixes-unstable branch
Message-Id: <20221116220835.6DA4BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email address for Satya Priya
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-satya-priya.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-satya-priya.patch

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

mailmap-update-email-address-for-satya-priya.patch

