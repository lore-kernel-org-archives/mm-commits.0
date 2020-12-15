Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBCFC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A2822CF8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgLOW4R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgLOW4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 17:56:09 -0500
Date:   Tue, 15 Dec 2020 14:55:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608072917;
        bh=g0TfkGzV16L+NczjASsJYU9vaJcTOx4ymZUMgRYmk4c=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=oN214cGj5TdU8/9/tVQgfevkXdl5YOJNfZnbc1iPHI9UetR+1rw4jHN2XE/LJc7wL
         2DYqotF+MHaqaO86jGtAQc3Jt7G4hdwHup3+9qzV5xnZ6ue/NchnjhT5Wjsu1Lpz/N
         qB6w7vh3n77/WW2i1SdYRovhMq86dYDPb0hsM2zc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: incoming
Message-Id: <20201215145517.a30e1708984276dec85c293c@linux-foundation.org>
In-Reply-To: <CAHk-=whiXW8dDgsYzb=gPRE3x6BeET9rsPF_5+x6Lf4bRR90-w@mail.gmail.com>
References: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
        <CAHk-=wi2-u8+m2k=dt-=L8sjHC=nR-Z7Db9igZDCjnkis1G9gA@mail.gmail.com>
        <CAHk-=whiXW8dDgsYzb=gPRE3x6BeET9rsPF_5+x6Lf4bRR90-w@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 15 Dec 2020 14:49:24 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Dec 15, 2020 at 2:48 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I will try to apply it on top of my merge of your previous series instead.
> 
> Yes, then it applies cleanly. So apparently we just have different
> concepts of what really constitutes a "base" for applying your series.
> 

oop, sorry, yes, the "based on" thing was wrong because I had two
series in flight simultaneously.  I've never tried that before..
