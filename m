Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C729C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 30 Oct 2023 19:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjJ3THZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Oct 2023 15:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjJ3THZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Oct 2023 15:07:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034BA9F
        for <mm-commits@vger.kernel.org>; Mon, 30 Oct 2023 12:07:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EF1C433C7;
        Mon, 30 Oct 2023 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698692842;
        bh=5QYcFCow4mwR+nftwKS4WVZJHkocikKmvFqooM9CITY=;
        h=Date:To:From:Subject:From;
        b=qxixvBnLMmn++PLRZdmkTGM3/pmfuG2iRxGGJAgXqEd2JkGFJFpcfm8cAUAzs0aav
         WY9Q/VD4EAFkVUhp+ZbmKh6cGYPQ/fWqEHldZggq/MdRfegZwJtx9sLg3d2shNFpig
         bdPnvH82Qt1oNrQejIRFglQp4LY/8/6Ll5rwgli0=
Date:   Mon, 30 Oct 2023 12:07:21 -0700
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        quic_bjorande@quicinc.com, o.rempel@pengutronix.de,
        kuba@kernel.org, konrad.dybcio@linaro.org, heiko@sntech.de,
        gregkh@linuxfoundation.org, benjamin.poirier@gmail.com,
        bagasdotme@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-benjamin-poiriers-address.patch added to mm-nonmm-unstable branch
Message-Id: <20231030190722.75EF1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: map Benjamin Poirier's address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-map-benjamin-poiriers-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-benjamin-poiriers-address.patch

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
Subject: .mailmap: map Benjamin Poirier's address
Date: Mon, 30 Oct 2023 21:24:55 +0700

Map out to his gmail address as he had left SUSE some time ago.

Link: https://lkml.kernel.org/r/20231030142454.22127-2-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-map-benjamin-poiriers-address
+++ a/.mailmap
@@ -95,6 +95,7 @@ Ben M Cahill <ben.m.cahill@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <ben@bwidawsk.net>
 Ben Widawsky <bwidawsk@kernel.org> <ben.widawsky@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <benjamin.widawsky@intel.com>
+Benjamin Poirier <benjamin.poirier@gmail.com> <bpoirier@suse.de>
 Bjorn Andersson <andersson@kernel.org> <bjorn@kryo.se>
 Bjorn Andersson <andersson@kernel.org> <bjorn.andersson@linaro.org>
 Bjorn Andersson <andersson@kernel.org> <bjorn.andersson@sonymobile.com>
_

Patches currently in -mm which might be from bagasdotme@gmail.com are

mailmap-map-benjamin-poiriers-address.patch

