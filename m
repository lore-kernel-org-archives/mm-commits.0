Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A91FC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 19:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJSTzb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiJSTz1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 15:55:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B601C8810
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 12:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBED1B825C0
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 19:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED91C433B5;
        Wed, 19 Oct 2022 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666209320;
        bh=DycglFzRc3dzWkLGduO5hA8mvJ64Za/DavquscPEEb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=joEm+2kpJrNyhTFjlN1ewaq/9tUBTssPk5swil22c6TOULcXePgOykSLRSrHWeVrp
         lGkc6W+t0wNizHWIuQEWpxNLrTb2xy+R2YT51ByUaCPX56RYuE8IYjEWtm6yZXps2e
         uSsRhFRtvv4yW0IQxfwTjqY6uRIog6nilfIhAkcU=
Date:   Wed, 19 Oct 2022 12:55:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com
Subject: Re: +
 mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch
 added to mm-unstable branch
Message-Id: <20221019125519.9041b2bd456f868b3bdaa260@linux-foundation.org>
In-Reply-To: <Y1BJATKCC+JnMS2E@casper.infradead.org>
References: <20220601204412.3A924C385A5@smtp.kernel.org>
        <Y1BJATKCC+JnMS2E@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 19 Oct 2022 19:59:13 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Wed, Jun 01, 2022 at 01:44:11PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch
> 
> This patch doesn't seem to have made it upstream yet ... what happened?
> I don't see it in mm-unstable any more, and I don't have an email saying
> that it was dropped.

That was around the time I was transitioning stuff into the git-based
workflow and I guess it got lost in the mayhem.  Thanks, I resurrected
it.

