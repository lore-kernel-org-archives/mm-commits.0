Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6989AC433E9
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D03564E8C
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhBECdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhBECdr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F1064FC0;
        Fri,  5 Feb 2021 02:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492363;
        bh=tv8nrrnJCYn6MPzzkknGiChZTFUZt73GkkBAEQLlBpc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VB044anPdAnrMlkrdCoZpqFuHyAgvBx8YhOoyvH5nRUJgzmVrKxmYhV/sdQ/T9m6k
         9kbAtfosWadaTiUwxjV/0tPV2/eST4fERRatjY9mgbLlLTPh5npFpOmwH6baxZ4J9V
         ruD5QbLgZiJTlh310zMs+wuQtUH2cWApQAoFEg4U=
Date:   Thu, 04 Feb 2021 18:32:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        manivannan.sadhasivam@linaro.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 12/18] mailmap: add entries for Manivannan
 Sadhasivam
Message-ID: <20210205023242.sQEW3FJ-_%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: mailmap: add entries for Manivannan Sadhasivam

Map my personal and work addresses to korg mail address.

Link: https://lkml.kernel.org/r/20210201104640.108556-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-manivannan-sadhasivam
+++ a/.mailmap
@@ -199,6 +199,8 @@ Li Yang <leoyang.li@nxp.com> <leoli@free
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Maciej W. Rozycki <macro@mips.com> <macro@imgtec.com>
+Manivannan Sadhasivam <mani@kernel.org> <manivannanece23@gmail.com>
+Manivannan Sadhasivam <mani@kernel.org> <manivannan.sadhasivam@linaro.org>
 Marcin Nowakowski <marcin.nowakowski@mips.com> <marcin.nowakowski@imgtec.com>
 Marc Zyngier <maz@kernel.org> <marc.zyngier@arm.com>
 Mark Brown <broonie@sirena.org.uk>
_
