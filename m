Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE11C46467
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 19:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjAPTwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 14:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbjAPTwc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 14:52:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8852BF2D
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 11:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cgpHY4rPJfZcBlPtolElyM2pYS/Xc+otbHixdRGcZ/k=; b=Mev2FOWj/XTbG1qWOKTXVufqe6
        OBk6PZvZntQuE4G1l6tMoX4oS7CVLir32JMIx4NYFEafTJMVWPOBy2yf6Mykp3ozLe04RKeN3+vwr
        26Mf7WPGo3/Mw117gVN5H2qC14iq4Q7ItaAqpYBvrZfL7a//VF1TRsrDqLkIqcYTKfFlOVGpNeFFZ
        S4k1xQDU1+Pd4xF2oXkeMX5PCLBtGhBNP1EbLcac0yl//HWM+ZEUx/hHS/8cyGCTsUzgT4WFkFwh3
        pJv73gFdw3Qm6CW/1cvsF2AQc5ZM+XZT2EhkjUMaxqjbF/PPL6tpTYnfNCHwmsE0sO2ho3OLV929j
        asVvlGMA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHVX9-0091Ul-Ih; Mon, 16 Jan 2023 19:52:43 +0000
Date:   Mon, 16 Jan 2023 19:52:43 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ran.xiaokai@zte.com.cn,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, bagasdotme@gmail.com,
        yang.yang29@zte.com.cn
Subject: Re: + swap_state-update-shadow_nodes-for-anonymous-page.patch added
 to mm-unstable branch
Message-ID: <Y8WrCwKDDRoEEuWr@casper.infradead.org>
References: <20230114044755.192CFC433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114044755.192CFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jan 13, 2023 at 08:47:54PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: swap_state: update shadow_nodes for anonymous page
> has been added to the -mm mm-unstable branch.  Its filename is
>      swap_state-update-shadow_nodes-for-anonymous-page.patch

I believe this patch to be buggy.  Please drop it (further discussion
in reply to the original patch)
