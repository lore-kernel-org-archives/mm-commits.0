Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F86C2BB9A
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 18:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A622250F
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 18:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440721AbgLNSUm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 13:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440743AbgLNSUl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 13:20:41 -0500
Date:   Mon, 14 Dec 2020 10:19:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607969998;
        bh=M+Dj5Vg7/iglbsYtP9MOZ/mAY99M/IHaT1jPuw2P0zc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nz+Xc4/xjwm+qn8K1JDjIqEwNYGAfz6hB0YXcJAHySOG410WiCd/9xRifhhbBwxqs
         yemJNUMRWtqNxInsnq1SeNymafxldNnm3pdHp6wh4r7g9/68k8+2zstuCj1AB9DwDZ
         HahHHP6rSHuQUysr1ZctOmclUZpOnSw3nYw1cYXI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc:     <aryabinin@virtuozzo.com>, <dvyukov@google.com>,
        <glider@google.com>, <guangye.yang@mediatek.com>,
        <matthias.bgg@gmail.com>, <miles.chen@mediatek.com>,
        <mm-commits@vger.kernel.org>, <nicholas.tang@mediatek.com>,
        <qcai@redhat.com>, <qiang.zhang@windriver.com>,
        <sfr@canb.auug.org.au>
Subject: Re: [merged]
 kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch removed from
 -mm tree
Message-Id: <20201214101957.51e0e05d2b7bf5d2f9707bd2@linux-foundation.org>
In-Reply-To: <1607924810.31376.14.camel@mtksdccf07>
References: <20201213060524.pmMPPz32b%akpm@linux-foundation.org>
        <1607924810.31376.14.camel@mtksdccf07>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 14 Dec 2020 13:46:50 +0800 Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com> wrote:

> On Sat, 2020-12-12 at 22:05 -0800, akpm@linux-foundation.org wrote:
> > The patch titled
> >      Subject: kasan: fix object remaining in offline per-cpu quarantine
> > has been removed from the -mm tree.  Its filename was
> >      kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch
> > 
> > This patch was dropped because it was merged into mainline or a subsystem tree
> > 
> 
> Hi Andrew,
> 
> Sorry to bother.
> This patch has dependency with two patches of Andrey's patch series as
> below.
> "kasan: rename get_alloc/free_info"
> "kasan: sanitize objects when metadata doesnt fit"

Are you sure?  Please check 5.10 and if there are problems there,
please propose a standalone fix.

