Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A58C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 11:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E31611CA
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 11:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhEMLNH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 07:13:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:54188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231255AbhEMLNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 07:13:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 80976AF3B;
        Thu, 13 May 2021 11:11:56 +0000 (UTC)
Date:   Thu, 13 May 2021 12:11:53 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org,
        hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, oleksiy.avramchenko@sonymobile.com,
        rostedt@goodmis.org, willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210513111153.GL3672@suse.de>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
 <20210513085602.6d3f9d63@canb.auug.org.au>
 <20210513103156.GA1856@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210513103156.GA1856@pc638.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 12:31:56PM +0200, Uladzislau Rezki wrote:
> On Thu, May 13, 2021 at 08:56:02AM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > On Wed, 12 May 2021 13:29:52 -0700 akpm@linux-foundation.org wrote:
> > >
> > > The patch titled
> > >      Subject: mm/vmalloc: print a warning message first on failure
> > > has been removed from the -mm tree.  Its filename was
> > >      mm-vmalloc-print-a-warning-message-first-on-failure.patch
> > > 
> > > This patch was dropped because it had testing failures
> > 
> > Removed from linux-next.
> > 
> What can of testing failures does it trigger? Where can i find the
> details, logs or tracers of it?

https://lore.kernel.org/linux-next/20210512175359.17793d34@canb.auug.org.au/

-- 
Mel Gorman
SUSE Labs
