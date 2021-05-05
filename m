Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3ACC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 03:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F7FF613CB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 03:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhEEDRF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 23:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhEEDRE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 23:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ADFA6139A;
        Wed,  5 May 2021 03:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620184569;
        bh=GIiPDF3LD6cHm5/MuntC+ViEXXTZRPAkIuRcKdSTijM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ed4W7ymjJi3NunLB118AQzpGhjUx6PK3u2JTAtleIXk555zt3Nn4kb1Mx8ZL27BNk
         l+XjNYnvDj2gCCmrt61TD4MeYg4UWwH4xXlW/0tBlb2u8969EqR/96gO4fP5eImQQe
         OhShLlukP/AWLo7cUmqug7d2ot5ZgUbhxnY9m4AM=
Date:   Tue, 4 May 2021 20:16:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: incoming
Message-Id: <20210504201608.5e5f94e76f7eed7264285c28@linux-foundation.org>
In-Reply-To: <CAHk-=wjzDtUVs9To0nMerMt-XDiP3JH2ee=1A9z+0onQaFD4KQ@mail.gmail.com>
References: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
        <CAHk-=wjzDtUVs9To0nMerMt-XDiP3JH2ee=1A9z+0onQaFD4KQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 4 May 2021 18:47:19 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, May 4, 2021 at 6:32 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > 143 patches
> 
> Hmm. Only 140 seem to have made it to the list, with 103, 106 and 107 missing.
> 
> Maybe just some mail delay? But at least right now
> 
>    https://lore.kernel.org/mm-commits/
> 
> doesn't show them (and thus 'b4' doesn't work).
> 
> I'll check again later.
> 

Well that's strange.  I see all three via cc:me, but not on linux-mm or
mm-commits.

Let me resend right now with the same in-reply-to.  Hopefully they will
land in the correct place.
