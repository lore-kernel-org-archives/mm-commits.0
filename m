Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F185C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiDLXTc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiDLXTW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:19:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C1076E3B
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 16:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 036B7CE20D0
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 23:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7752C385A5;
        Tue, 12 Apr 2022 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649805022;
        bh=+9puWWfYbMeEcSGfiV3ZOYHeslnjkDM1IDqjNWLmsE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LybJmoK5Y7EOfj5pKQne2lbyH+r11bcJ4HXAGw0zsqpcJ652sD+jl5GCS8ZV07dzd
         0QeTojTeGMRqbH4o1QCeTelERuVqVCgNzq0RpOU2jZxK2IU50U0vOwHl3ahDICfcxT
         XeiOH21leDTvO3HzsLEL5liWEP1AT/D7NETTKpbc=
Date:   Tue, 12 Apr 2022 16:10:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        urezki@gmail.com, npiggin@gmail.com, dingtianhong@huawei.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        aklimov@redhat.com
Subject: Re: [to-be-updated] vmap-dont-allow-invalid-pages.patch removed
 from -mm tree
Message-Id: <20220412161020.74608b5910e5d972cb05566b@linux-foundation.org>
In-Reply-To: <YlMINMJ1lhj9lkK4@yury-laptop>
References: <20220321211611.C59E9C340E8@smtp.kernel.org>
        <YlMINMJ1lhj9lkK4@yury-laptop>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 10 Apr 2022 09:39:16 -0700 Yury Norov <yury.norov@gmail.com> wrote:

> On Mon, Mar 21, 2022 at 02:16:11PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm/vmalloc.c: vmap(): don't allow invalid pages
> > has been removed from the -mm tree.  Its filename was
> >      vmap-dont-allow-invalid-pages.patch
> > 
> > This patch was dropped because an updated version will be merged
> 
> Hi Andrew,
> 
> Can you please clarify what updated version did you mean? Are you
> waiting for a v3 from me with extended patch comment, or something
> else?

yup.

https://lkml.kernel.org/r/CAAH8bW9s9ENa7QOExV3rOqn-LAEu1RrQd+ijor9o=jhGxm=6ew@mail.gmail.com

"I'll send v3 soon with more details in the patch description."
