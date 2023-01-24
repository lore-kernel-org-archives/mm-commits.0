Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E4BC54EED
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 21:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjAXV4W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjAXV4V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 16:56:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF80027D70
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 13:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cqvcZqK/Mbr+vl8rvBtA7wmqZWACyYbiX4xtBj4OJOc=; b=oikzayWAXTj1plsccPakrSgb94
        4r/D6Q/Uo1CLOsQjnE8qAHlFuw4AG29aSABud5Fa/mifVbRZZx6f/PJslmdCfK8rCWYV4JtoGTUk+
        45LBNwa5gC6VdQ50i1HGwBBNZWORAJJ2KncHDqy04AomwxBhth538siVeOZQNPvayTLXJfh4iKe/H
        IbKcIqennvcKkW7DWPkDKHdnQUGakeJ59LmkJt/sKpF0jpWXXJZV/l+D+M1i/ZSfN+UK6KS0RLcMu
        GQLTJLMsNhPmhQF1e9IPIJQDGp6I7aXDYm+gwEosIwdxu80U6vMl+CuInaO5R2E36jcn61MZVvi5L
        NolwmTgA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKRH4-005O3q-HH; Tue, 24 Jan 2023 21:56:14 +0000
Date:   Tue, 24 Jan 2023 21:56:14 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vishal.moola@gmail.com
Subject: Re: + mm-add-folio_estimated_mapcount.patch added to mm-unstable
 branch
Message-ID: <Y9BT/uHMeP/3ytht@casper.infradead.org>
References: <20230124215305.23B14C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124215305.23B14C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jan 24, 2023 at 01:53:04PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: add folio_estimated_mapcount()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-add-folio_estimated_mapcount.patch

Um, there was a build breakage report from one of the bots on this
patch.  Probably better to hold off on this series for now.
