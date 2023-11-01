Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214C0C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348070AbjKATrq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347400AbjKATrh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D5C120
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB5AC433C9;
        Wed,  1 Nov 2023 19:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868052;
        bh=1gO815NCmDczE6BWkpkezSUSjniG7ofg5d4TVmIRbaY=;
        h=Date:To:From:Subject:From;
        b=E9Q0xRgl8rFF19tQHKsZiBCoBlt2sZC1kFtT5mCsWEGkcq59Wjiy+PrXEuWfW+yV6
         00Epb8liCD0vBlnTa0fuRxuUtb5h77B5K5f6in41A2UxS8necNvMCrtCb8v9KfG7y4
         uiuJh8CyLGWVPhn/TJ59cCrw5oYG2969o9IOR/g8=
Date:   Wed, 01 Nov 2023 12:47:31 -0700
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        quic_bjorande@quicinc.com, o.rempel@pengutronix.de,
        kuba@kernel.org, konrad.dybcio@linaro.org, heiko@sntech.de,
        gregkh@linuxfoundation.org, benjamin.poirier@gmail.com,
        bagasdotme@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-map-benjamin-poiriers-address.patch removed from -mm tree
Message-Id: <20231101194732.6AB5AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: .mailmap: map Benjamin Poirier's address
has been removed from the -mm tree.  Its filename was
     mailmap-map-benjamin-poiriers-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -94,6 +94,7 @@ Ben M Cahill <ben.m.cahill@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <ben@bwidawsk.net>
 Ben Widawsky <bwidawsk@kernel.org> <ben.widawsky@intel.com>
 Ben Widawsky <bwidawsk@kernel.org> <benjamin.widawsky@intel.com>
+Benjamin Poirier <benjamin.poirier@gmail.com> <bpoirier@suse.de>
 Bjorn Andersson <andersson@kernel.org> <bjorn@kryo.se>
 Bjorn Andersson <andersson@kernel.org> <bjorn.andersson@linaro.org>
 Bjorn Andersson <andersson@kernel.org> <bjorn.andersson@sonymobile.com>
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


