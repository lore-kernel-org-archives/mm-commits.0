Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD03C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 18:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiJSS7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 14:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJSS7Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 14:59:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9BA1C5A52
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 11:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=x6z1JTnxpIAtTCK6ajdFKbtfvpNDc7C67y5tYzj53jk=; b=qh0+SW5rgSbvAs8GIkin0fkwD+
        j88nkCgOVALkq/HYRT+LwTLcUuhYZyQpv4ROF147Lf0mrhO3Vaz0dQQPbvdexnIHeKLiJOi9b4oq5
        sv7WQKg2wivajmpmSR9d7qXyoiyuMHA8ArSHAN6sGTqQmnxZNCv+7XHbtb3bFQrnhHRDsIhz5V1ML
        pftRx7vTc4YGDdLR969Gk+eN1n2Ro70JFK2QtzJVOYhGN+Q5nlL5B3Mjssm4EowwGBOIctBbrIYVf
        OAc4EHiGvWZzNwTD/sAcf+hdkCBFJbfooPTf3HDSMheRixBNfXvjzCI37ijFY00mw+6DOLtLdG0cM
        heyDNZlA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1olEHZ-00Bm3F-Gd; Wed, 19 Oct 2022 18:59:13 +0000
Date:   Wed, 19 Oct 2022 19:59:13 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com
Subject: Re: +
 mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch added
 to mm-unstable branch
Message-ID: <Y1BJATKCC+JnMS2E@casper.infradead.org>
References: <20220601204412.3A924C385A5@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601204412.3A924C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 01, 2022 at 01:44:11PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch

This patch doesn't seem to have made it upstream yet ... what happened?
I don't see it in mm-unstable any more, and I don't have an email saying
that it was dropped.
