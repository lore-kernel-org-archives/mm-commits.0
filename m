Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC3DC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77FA164E56
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhBHRYR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234888AbhBHRXT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 12:23:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F6964EC3;
        Mon,  8 Feb 2021 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612804862;
        bh=lmuYIYyE8gamZ7jzMpLQ/S1bQZJHx1M3bMiaAIoXDZQ=;
        h=Date:From:To:Subject:From;
        b=E/zEgoivXgb9W+DHkgoOlmaXWrzjreP2xUV14hzWO45lAtw3lQnUjKx2zEcJhk3pG
         ZwB2uU7t1FCfVrUvaj8IHPyAp0Wx44KNNFVIsYS+RU+xyAbrtE+WSXfXRJ4DmgFlLo
         OQKXqI+rACq6fzL85NJ9EUhKhD5FR3Nl3YHP4rJ8=
Date:   Mon, 08 Feb 2021 09:21:02 -0800
From:   akpm@linux-foundation.org
To:     manivannan.sadhasivam@linaro.org, mm-commits@vger.kernel.org
Subject:  [merged]
 mailmap-add-entries-for-manivannan-sadhasivam.patch removed from -mm tree
Message-ID: <20210208172102.xPrIDCxS7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entries for Manivannan Sadhasivam
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-manivannan-sadhasivam.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from manivannan.sadhasivam@linaro.org are


