Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8929CC4167D
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347404AbjKATrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348062AbjKATri (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8441F121
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211D8C43395;
        Wed,  1 Nov 2023 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868055;
        bh=SzkCER0obWNzUr29GPVvweBCEk+4WKZE2gMQi7m8lDc=;
        h=Date:To:From:Subject:From;
        b=BCsJe98zBetlXAfYztOkjxvxgnXF/j2+YeTAAise10rpBmlc4ChZMcBCxiGThacbB
         oMd1gFvpTqvSvgGjNyq4BsLRST8AKC+kwIsRZmm9CkmTZj3kjPPA7lctK5uSM+Itj2
         EI+K9aVOJUhE4LiFo09EzME7HOUyRToOGnevyCzQ=
Date:   Wed, 01 Nov 2023 12:47:34 -0700
To:     mm-commits@vger.kernel.org, tomeu@tomeuvizoso.net,
        stephen@networkplumber.org, quic_bjorande@quicinc.com,
        kuba@kernel.org, konrad.dybcio@linaro.org, heiko@sntech.de,
        axboe@kernel.dk, bagasdotme@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-address-mapping-for-tomeu-vizoso.patch removed from -mm tree
Message-Id: <20231101194735.211D8C43395@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: .mailmap: add address mapping for Tomeu Vizoso
has been removed from the -mm tree.  Its filename was
     mailmap-add-address-mapping-for-tomeu-vizoso.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: .mailmap: add address mapping for Tomeu Vizoso
Date: Tue, 31 Oct 2023 08:40:00 +0700

He's no longer working in Collabora (and his email address there bounces).
Map it to his personal address.

Link: https://lkml.kernel.org/r/20231031014009.22765-2-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-address-mapping-for-tomeu-vizoso
+++ a/.mailmap
@@ -567,6 +567,7 @@ Takashi YOSHII <takashi.yoshii.zj@renesa
 Tamizh Chelvam Raja <quic_tamizhr@quicinc.com> <tamizhr@codeaurora.org>
 Taniya Das <quic_tdas@quicinc.com> <tdas@codeaurora.org>
 Tejun Heo <htejun@gmail.com>
+Tomeu Vizoso <tomeu@tomeuvizoso.net> <tomeu.vizoso@collabora.com>
 Thomas Graf <tgraf@suug.ch>
 Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


