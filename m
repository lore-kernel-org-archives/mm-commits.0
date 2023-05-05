Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1856C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 23:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjEEXha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 19:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjEEXha (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 19:37:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE984EE0
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 16:37:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0218C64175
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 23:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283CFC433D2;
        Fri,  5 May 2023 23:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683329848;
        bh=QWUVQgW+HxNrR1Fi/5bFWyeruQZx6ZP+ox3LV5+mmmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=esNyKzyFClIxePiL+eMX62pkawu4Q+qtTempNHnKgpzQdDQkpup6smFdH4pOvp5nh
         6S9BBw3rEbvijtdkmvdhFI18PkcC1CC3BkAO6MD9wrl7dfQHq9z2PYQmyvDCnd5lXt
         jMHaZg2gEDKVOVJWck93SRPMM2H8/oXscOK3eEbw=
Date:   Fri, 5 May 2023 16:37:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, marc.dionne@auristor.com, jack@suse.cz,
        dhowells@redhat.com, hch@lst.de
Subject: Re: [merged mm-hotfixes-stable]
 filemap-fix-the-conditional-folio_put-in-filemap_fault.patch removed from
 -mm tree
Message-Id: <20230505163727.b4d285010a8df10e027208f9@linux-foundation.org>
In-Reply-To: <ZFWL1QyYs8asYDzR@casper.infradead.org>
References: <20230505224305.B7761C433D2@smtp.kernel.org>
        <ZFWL1QyYs8asYDzR@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 6 May 2023 00:05:57 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, May 05, 2023 at 03:43:05PM -0700, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >      Subject: filemap: fix the conditional folio_put in filemap_fault
> > has been removed from the -mm tree.  Its filename was
> >      filemap-fix-the-conditional-folio_put-in-filemap_fault.patch
> > 
> > This patch was dropped because it was merged into the mm-hotfixes-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> I thought i nacked this?

This? https://lkml.kernel.org/r/ZFMn0zGC58KtQw6N@casper.infradead.org

I interpret that as "doh, never mind"?
