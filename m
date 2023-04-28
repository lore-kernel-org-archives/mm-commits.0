Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6E8C77B7E
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 05:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjD1FhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 01:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345141AbjD1Fg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 01:36:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEEB359D;
        Thu, 27 Apr 2023 22:36:58 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A426268D0A; Fri, 28 Apr 2023 07:36:54 +0200 (CEST)
Date:   Fri, 28 Apr 2023 07:36:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
Message-ID: <20230428053654.GA8549@lst.de>
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org> <CAHk-=wjaYXeWKsyifQCS=gJf4mxav-b6cdf5boKpMO6M1C-2LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjaYXeWKsyifQCS=gJf4mxav-b6cdf5boKpMO6M1C-2LQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 27, 2023 at 08:15:56PM -0700, Linus Torvalds wrote:
> Most of the bulk of the conflicts were around __filemap_get_folio()
> now returning an ERR_PTR, particularly then with Willy doing the ext4
> folio conversion.
> 
> So Christoph, Willy, mind just double-checking me?

The merge looks fine to me.
