Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B02C00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 13:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245073AbiHRNZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 09:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiHRNZi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 09:25:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32B49FA81
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 06:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pC5eQ16veurqQ+97grIkKx6nX5eJdeL+B2m8TQX/gTE=; b=AuuhtLAohAiPGhk883RwuWDvXP
        VIiSb2Dt2WM34YytpnsFBguUuxeOG43JKEmKytA1vA58q0FOaybr6S49xMW65F6orPSe0PDZc3yGM
        otYhp+nP67MLCAF/zLCaGHTEnXJSRjTRD5e1x5GcQaLjdJy38Ecnye2OJsyca+lM544Vsd767q4VA
        8wrvFjauIJPXVR5VckBj/IEFInHrbXx17aMpKpagE8YVpE+quypWPAbLRoXrjVLMKWKe1txYCHKej
        E0Sz/x8OuTjgsZf0z/PtYucJHTS7Op1OjbfyEElmiv73B6Egh9aNoRPnpHpLft+wAGPVGWdzXo+ul
        TOk1ZTWw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oOfWd-009pB9-ND; Thu, 18 Aug 2022 13:25:31 +0000
Date:   Thu, 18 Aug 2022 14:25:31 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, kent.overstreet@gmail.com,
        kanie@linux.alibaba.com
Subject: Re: + mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch
 added to mm-hotfixes-unstable branch
Message-ID: <Yv49y/equPyt4NCq@casper.infradead.org>
References: <20220817151814.E1F5FC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817151814.E1F5FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Aug 17, 2022 at 08:18:14AM -0700, Andrew Morton wrote:
> The patch titled
>      Subject: mm/filemap.c: fix the timing of asignment of prev_pos
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch

Please drop this patch.
