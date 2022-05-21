Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAE4C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 21 May 2022 03:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354400AbiEUDBu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 May 2022 23:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347782AbiEUDBt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2022 23:01:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA342B197
        for <mm-commits@vger.kernel.org>; Fri, 20 May 2022 20:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 397B9B82ECD
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 03:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB25C385A9;
        Sat, 21 May 2022 03:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653102105;
        bh=0n0GFBAUNvKHqaPPM3Y/fvhVDG752l74JJ+PzcueN78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JJlGfNXavjcYnOgzrzoVyv8QCjvyylltuRkdLsFFUZL6O0tcKN551PUUi8bYeaT5d
         UsHu6ZiXJudZXzpZsAwGz6WeGqR/ozcAZu4OXdyOwIxHlu88OjgsAD4EOLBaupRUmT
         ZvObduYOksf8Ou7vItDJkiSXr1QK3OzL6FTjg/sc=
Date:   Fri, 20 May 2022 20:01:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        paulmck@kernel.org, joaodias@google.com, jhubbard@nvidia.com,
        david@redhat.com
Subject: Re: [alternative-merged]
 mm-fix-is_pinnable_page-against-on-cma-page.patch removed from -mm tree
Message-Id: <20220520200143.f586281a7014d6c4bf986668@linux-foundation.org>
In-Reply-To: <YogLKAuBnDfSJjwm@google.com>
References: <20220517194801.85817C385B8@smtp.kernel.org>
        <YogLKAuBnDfSJjwm@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 20 May 2022 14:42:00 -0700 Minchan Kim <minchan@kernel.org> wrote:

> On Tue, May 17, 2022 at 12:48:00PM -0700, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >      Subject: mm: fix is_pinnable_page against on cma page
> > has been removed from the -mm tree.  Its filename was
> >      mm-fix-is_pinnable_page-against-on-cma-page.patch
> > 
> > This patch was dropped because an alternative patch was merged
> 
> Hi Andrew,
> 
> I didn't see what an alternative patch was merged.

I'll update that text to "was or shall be" :)


