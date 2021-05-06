Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC86BC433ED
	for <mm-commits@archiver.kernel.org>; Thu,  6 May 2021 03:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84138613BA
	for <mm-commits@archiver.kernel.org>; Thu,  6 May 2021 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEFDUE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 May 2021 23:20:04 -0400
Received: from foss.arm.com ([217.140.110.172]:55436 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232884AbhEFDUA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 5 May 2021 23:20:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66A251FB;
        Wed,  5 May 2021 20:19:02 -0700 (PDT)
Received: from [192.168.0.130] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A856C3F73B;
        Wed,  5 May 2021 20:19:00 -0700 (PDT)
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
 <CAHk-=wjzDtUVs9To0nMerMt-XDiP3JH2ee=1A9z+0onQaFD4KQ@mail.gmail.com>
 <20210504201608.5e5f94e76f7eed7264285c28@linux-foundation.org>
 <CAHk-=wgOGM5u0Kcx0L0u58D9ms6vQ=LwtJNMNd4xmAjQ+jcQSw@mail.gmail.com>
 <20210505104401.75fc14e7de7573c26c4c49d4@linux-foundation.org>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <9d1f770a-3ea0-9d73-e47d-4eb1f2de123d@arm.com>
Date:   Thu, 6 May 2021 08:49:47 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210505104401.75fc14e7de7573c26c4c49d4@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 5/5/21 11:14 PM, Andrew Morton wrote:
> On Wed, 5 May 2021 10:10:33 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Tue, May 4, 2021 at 8:16 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>> Let me resend right now with the same in-reply-to.  Hopefully they will
>>> land in the correct place.
>> Well, you re-sent it twice, and I have three copies in my own mailbox,
>> bot they still don't show up on the mm-commits mailing list.
>>
>> So the list hates them for some odd reason.
>>
>> I've picked them up locally, but adding Konstantin to the participants
>> to see if he can see what's up.
>>
>> Konstantin: patches 103/106/107 are missing on lore out of Andrew's
>> series of 143. Odd.
> It's weird.  They don't turn up on linux-mm either, and that's running
> at kvack.org, also majordomo.  They don't get through when sent with
> either heirloom-mailx or with sylpheed.
> 
> Also, it seems that when Anshuman originally sent the patch, linux-mm
> and linux-kernel didn't send it back out.  So perhaps a spam filter
> triggered?
> 
> I'm seeing
> 
> https://lore.kernel.org/linux-arm-kernel/1615278790-18053-3-git-send-email-anshuman.khandual@arm.com/
> 
> which is via linux-arm-kernel@lists.infradead.org but the linux-kernel
> server massacred that patch series.  Searching
> https://lkml.org/lkml/2021/3/9 for "anshuman" only shows 3 of the 7
> email series.

Yeah these patches faced problem from the very beginning getting
into the MM/LKML list for some strange reason.
