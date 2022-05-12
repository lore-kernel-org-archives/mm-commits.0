Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B84FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 20:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358617AbiELU6S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 16:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358619AbiELU6G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 16:58:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46286B65F
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 13:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MGX+DzolvQY4QoFsJjHWb/MSe4z99c24k7/zqfFwCWU=; b=OixF6YJ7WcCet6yqqwXRCr4Tvs
        GUX5FV0sQVkxy1nR4jurBvh9t7l7tGvZNNupxglmrKL+jWBQ4Ptk84Z1JYgZcJynxgIfc+yvB5/oC
        rrvz0njHApNM1LhLOs7y7vXZ8YTNTLxs4jzdXMoae8zCyPfpoiOkLbQt6d0gHwaauebAWdamBnARS
        Nc1Cs1k0Ipk13MauS2qiUsj+Qrt373HNzXSkoqX//9Vn7AncUp9e5wJohZsnQzpE2BJm1SFKJhL+F
        MD2imqwK2ZrB0ubOMKO2hwp7YoWDkPdMmes0+CngvYkHIVDq7hHx9SWWnxQiF7b8375CY+//gRBBH
        YcQKqZ5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1npFsE-006k6T-KM; Thu, 12 May 2022 20:57:26 +0000
Date:   Thu, 12 May 2022 21:57:26 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        zhang.yunkai@zte.com.cn, yang.yang29@zte.com.cn,
        wang.yong12@zte.com.cn, ran.xiaokai@zte.com.cn,
        ammarfaizi2@gnuweeb.org, xu.xin16@zte.com.cn
Subject: Re: + mm-ksm-introduce-ksm_force-for-each-process.patch added to
 mm-unstable branch
Message-ID: <Yn10to1478Mu4p81@casper.infradead.org>
References: <20220512204206.57AA6C385B8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512204206.57AA6C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 12, 2022 at 01:42:05PM -0700, Andrew Morton wrote:
> The patch titled
>      Subject: mm/ksm: introduce ksm_force for each process
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-ksm-introduce-ksm_force-for-each-process.patch

Oh.  I thought Oleksandr Natal's objections were enough to keep this
out.  I have objections to its implementation, but I didn't bother
after Oleksander went after the concept.
