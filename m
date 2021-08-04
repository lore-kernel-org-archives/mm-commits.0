Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABB9C4338F
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 04:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D64360F0F
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 04:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhHDEhI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Aug 2021 00:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhHDEhH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Aug 2021 00:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 993A660F25;
        Wed,  4 Aug 2021 04:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628051814;
        bh=TfFmWfyk8ZA85AsLMiCbO6oC9kUVWBH2XCawKWSv+BY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6LUs066qUvx+Vg/AqcuzO8AyYoPpHSI8LqKOORHFx7pBvHMOkwBzencVbd4RUW/q
         Gm1MueswxuwiL/4QbtMJMH/zv5/Ejt40GqUY87cNi2d3ZZwlPavdzg62WWLYMX0Evs
         47Mi6ILgx5WJEhAqpe52CyRxHp58Wzz7EEpgwvkM=
Date:   Tue, 3 Aug 2021 21:36:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        masahiroy@kernel.org, nathan@kernel.org
Subject: Re: +
 scripts-recordmcountpl-remove-check_objcopy-and-can_use_local.patch added
 to -mm tree
Message-Id: <20210803213653.49d53b90f9e03bd11b5fc293@linux-foundation.org>
In-Reply-To: <20210803212911.48f3924a@rorschach.local.home>
References: <20210802213040.ED4ON%akpm@linux-foundation.org>
        <20210803212911.48f3924a@rorschach.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 3 Aug 2021 21:29:11 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 02 Aug 2021 14:30:40 -0700
> akpm@linux-foundation.org wrote:
> 
> > The patch titled
> >      Subject: scripts/recordmcount.pl: remove check_objcopy() and $can_use_local
> > has been added to the -mm tree.  Its filename is
> >      scripts-recordmcountpl-remove-check_objcopy-and-can_use_local.patch
> 
> Thanks Andrew,
> 
> But I'll pulling it through my tree.
> 
> I'll even send it up with my urgent push into the -rc release.

If/when it turns up in linux-next, I drop my copy (after checking it
was the same),

So it's all basically automatic - no need to tell me!
