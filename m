Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415E4C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2468C613BE
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGJADx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 20:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhGJADx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 20:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40086613C2;
        Sat, 10 Jul 2021 00:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625875269;
        bh=nQvu1iMQns4DxwstXzh2D+2x/Ip7qtW8ldrM6DcVbHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZEzWlI1fZ0hofjP9r5R+kb07M4o3eMxT+XOz0cAwb6ccbj2L1TvTtf/Hu8yb961qm
         nW16fFA86C5ZdO59cKJyOFSqsvwLcydEr5RdgfjqYV+tU+qYd5mLk1yKgnrqlYjUzS
         ULtzKJ27Uve8gZpsWV8lQsaYHzhj01dBfm3ryh5M=
Date:   Fri, 9 Jul 2021 17:01:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: +
 mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
 added to -mm tree
Message-Id: <20210709170108.70a09b28e74ca0c3795c9117@linux-foundation.org>
In-Reply-To: <CAJuCfpG4JenxJX+-QpHBNkX=MY9hGhh1gTHp5z8vumeZNrCCdQ@mail.gmail.com>
References: <20210709222253.W41zC%akpm@linux-foundation.org>
        <CAJuCfpG4JenxJX+-QpHBNkX=MY9hGhh1gTHp5z8vumeZNrCCdQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 9 Jul 2021 16:35:18 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> On Fri, Jul 9, 2021 at 3:22 PM <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config
> > has been added to the -mm tree.  Its filename is
> >      mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> >
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> 
> Hi Andrew,
> Please note that this patch is the second in the series of 3 here:

This patch had "[PATCH v2 1/1]" in the title.  Poor me.

> https://lore.kernel.org/patchwork/project/lkml/list/?series=507567 and
> the only one that needed a v2 (others seem to be fine and are Ack'ed).
> If you would like me to respin the whole series please let me know.

Yes please.


