Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CDAC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 31 Oct 2023 15:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344388AbjJaPCX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Oct 2023 11:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344312AbjJaPCW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Oct 2023 11:02:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90FFE4
        for <mm-commits@vger.kernel.org>; Tue, 31 Oct 2023 08:02:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57740C433C8;
        Tue, 31 Oct 2023 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698764540;
        bh=s3JVWSPiCuM/yUaYlBTUBdtuRBUEkRhfrW8NWJt2pIU=;
        h=Date:To:From:Subject:From;
        b=SNK6XcCuinmaXCkPfp08nnuobx0fPQJA1r4qg69ysg53lv9N5JpDNfNrAHtSWXR7z
         sbcG81fuQQo9CfFw+N6sux7p8ZsTPrmjPt5GkO9XLm9y6DRwHNbxhjjspwb74bguxv
         iJlbW4L+V5Ucjg2yVYfzQEgmT6b+nuAiE2A1yyro=
Date:   Tue, 31 Oct 2023 08:02:19 -0700
To:     mm-commits@vger.kernel.org, tomeu@tomeuvizoso.net,
        stephen@networkplumber.org, quic_bjorande@quicinc.com,
        kuba@kernel.org, konrad.dybcio@linaro.org, heiko@sntech.de,
        axboe@kernel.dk, bagasdotme@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-address-mapping-for-tomeu-vizoso.patch added to mm-nonmm-unstable branch
Message-Id: <20231031150220.57740C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: add address mapping for Tomeu Vizoso
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-address-mapping-for-tomeu-vizoso.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-address-mapping-for-tomeu-vizoso.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: .mailmap: add address mapping for Tomeu Vizoso
Date: Tue, 31 Oct 2023 08:40:00 +0700

He's no longer working in Collabora (and his email address there bounces).
Map it to his personal address.

Link: https://lkml.kernel.org/r/20231031014009.22765-2-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-address-mapping-for-tomeu-vizoso
+++ a/.mailmap
@@ -569,6 +569,7 @@ Takashi YOSHII <takashi.yoshii.zj@renesa
 Tamizh Chelvam Raja <quic_tamizhr@quicinc.com> <tamizhr@codeaurora.org>
 Taniya Das <quic_tdas@quicinc.com> <tdas@codeaurora.org>
 Tejun Heo <htejun@gmail.com>
+Tomeu Vizoso <tomeu@tomeuvizoso.net> <tomeu.vizoso@collabora.com>
 Thomas Graf <tgraf@suug.ch>
 Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
_

Patches currently in -mm which might be from bagasdotme@gmail.com are

mailmap-map-benjamin-poiriers-address.patch
mailmap-add-address-mapping-for-tomeu-vizoso.patch

