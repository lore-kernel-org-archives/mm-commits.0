From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + dma-buf-free-dmabuf-name-in-dma_buf_release.patch added to
 -mm tree
Date: Wed, 26 Feb 2020 20:20:33 -0800
Message-ID: <20200226202033.c3fccbaca353e110b1a3bf00@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
        <20200226015504.7GW9ptoIA%akpm@linux-foundation.org>
        <CAO_48GFr9-aY4=kRqWB=UkEzPj5fQDip+G1tNZMsT0XoQpBC7Q@mail.gmail.com>
        <CAKMK7uGvixQ2xoQMt3pvt0OpNXDjDGTvSWsaAppsKrmO_EP3Kg@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbgB0EUg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 Feb 2020 23:20:36 -0500
In-Reply-To: <CAKMK7uGvixQ2xoQMt3pvt0OpNXDjDGTvSWsaAppsKrmO_EP3Kg@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, mm-commits@vger.kernel.org, Chenbo Feng <fengc@google.com>, DRI mailing list <dri-devel@lists.freedesktop.org>, Greg Hackmann <ghackmann@google.com>, WANG Cong <xiyou.wangcong@gmail.com>, "open list:DMA BUFFER SHARING FRAMEWORK" <linux-media@vger.kernel.org>

On Wed, 26 Feb 2020 10:36:26 +0100 Daniel Vetter <daniel@ffwll.ch> wrote:

> On Wed, Feb 26, 2020 at 5:29 AM Sumit Semwal <sumit.semwal@linaro.org> wrote:
> >
> > Hello Andrew,
> >
> >
> > On Wed, 26 Feb 2020 at 07:25, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > >
> > > The patch titled
> > >      Subject: dma-buf: free dmabuf->name in dma_buf_release()
> > > has been added to the -mm tree.  Its filename is
> > >      dma-buf-free-dmabuf-name-in-dma_buf_release.patch
> >
> > Thanks for taking this patch via -mm during my absence (I'm just
> > returning from a bit of an illness). If there are other dma-buf
> > patches on your radar that you'd like to take via the mm tree, please
> > let me know and I can provide the necessary Acks.
> > Else I will take them in via drm-misc as usual.
> 
> I thought at least that for cases like these -mm is the last resort
> tree, so proper thing to do here is apply this fix to drm-misc-fixes
> and get it out there. -mm rebases, so will fall out again.

Yup, go ahead.  If a patch pops up in linux-next I'll autodrop by copy.

And please do give some thought to whether this should be cc:stable. 
If it's an unprivileged operation then hellyeah.
