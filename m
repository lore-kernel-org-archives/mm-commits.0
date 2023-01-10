Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D9BC54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 14:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbjAJOYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 09:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbjAJOYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 09:24:34 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480D88E9B0
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 06:24:33 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 22773604F3;
        Tue, 10 Jan 2023 15:24:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673360669; bh=OdxaKmz9WbJ6Nx7VuRFa1M7pm3LtroPlD2UcyCwj5FA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=hdjY5gAMhk9ozCtOK1JfUXM5Hwc8Q/IuYYPycW75uvw1WTgbOFJIQWD39nQeHW0Ed
         ZZmm9k/g5KfbJyyK/hUqYtJ8Ztgc5u3VrHG1xUnGUQtkyZzX5MtzqcaNMiUTlZqrQu
         ba+xBAk1lEi+6vTDHS80MIfOak6dUI/A3b9+JqmbBYg1c9Vd4t/PhfcJcke9PPkyIp
         HGWL9ZE0HFydSrHNjyQtTVH8S5HO0I7f5PLegpccuahQht56yrTvyfl+QDLT6o8tZs
         1X2kiPs15dfr8bcCFmAk3fgBynx6ljqdouksSMcrwKbNdATfa0BI/6uumheZYD8Gr7
         7QDo0Kf53lDYg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zLo_wG67Lz3m; Tue, 10 Jan 2023 15:24:26 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id BCF22604F2;
        Tue, 10 Jan 2023 15:24:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673360666; bh=OdxaKmz9WbJ6Nx7VuRFa1M7pm3LtroPlD2UcyCwj5FA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=aHD459SdLV7+14rNQOOZl0gGIGbGtJAlJie8WgWgyDO+rD3z/HDP1f4bCf8uluz4O
         XNVHhpJ9z4HJX/g+tVZtrX8eC0H0x62N3kg5sp1t2ySySJcYxW1gsASrrgtVoYiYsb
         IBp/ZUx9qcZlEJHN92cyWAy/3yCQIXgdYfCz8IzsXV+ht6DDml96laFhS5iF9uA+QU
         cD62RqvqfDR8+SSiHuRDuBriqdcNXJBuvU0Y4xdL6FjGnvRE/bVv1avql5LAY8k1iZ
         u3k0bi/x5TiqJs42mGhqTajvJEqSOnyZzk5pIBiUWR0Bvt+iI0M2L5yPyArHxDQnXQ
         KC0+uLbP/tPxA==
Message-ID: <01aa2810-68c9-c17e-850e-c0a141e462f5@alu.unizg.hr>
Date:   Tue, 10 Jan 2023 15:24:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: +
 selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to
 mm-unstable branch
Content-Language: en-US, hr
To:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shuah@kernel.org
References: <20230109233601.C4082C433EF@smtp.kernel.org>
 <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
 <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
 <edb402df-c0df-00d7-3bf4-884c5ba47ca9@alu.unizg.hr>
 <738e358a-5ef0-0981-ba02-8a25367b9bc9@redhat.com>
 <ac38396d-51df-fff0-5b4c-3defea67dbe3@alu.unizg.hr>
 <01dd090b-451f-f926-a6f3-1739f0ef688b@redhat.com>
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <01dd090b-451f-f926-a6f3-1739f0ef688b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 1/10/23 15:04, David Hildenbrand wrote:
>>
>> Of course, we can easily test with "gcc -E" what exactly gets included.
>>
>> We don't seem to have a uniform way of handling MADV_PAGEOUT and
>> MADV_POPULATE(READ|WRITE) even within different C sources within
>> tools/testing/selftests/vm itself, so it means that we spread the spectrum
>> of systems and compilations that we will break. :-/
>>
>> To repeat what is obvious, I am not an authority on the Linux kernel,
>> but as I said, I have the benefit of a fresh perspective ...
>>
>> There was an open source proverb that "more eyes see more" :)
> 
> The thing is: I don't lose sleeps about defines that will never change as long as it compiles. That's the most important part (for 
> me) with these tests. Even if it would change, and I don't see how, we'd get test failures and could fix it up.
> 
> ... and I raised that I ran into issues with what you propose. That's really all I am saying :)
> 
> And to repeat what I said: If we can find a cleanup for all these relevant "ifndef" in selftests/mm I'd be very happy. As long as it 
> compiles I'm all for cleanups. It would also be acceptable to say "what David tested was wrong" -- but that needs clear justification.

Then I rest my case.

Just to assert:

Probably if MADV_PAGEOUT or MADV_POPULATE_(READ|WRITE) isn't defined in in-tree
includes, then also the kernel wouldn't support them.

#include <sys/mman.h>
#include <linux/mman.h>

#ifdef MADV_PAGEOUT
         if (swapout) {
                 madvise(mem, pagesize, MADV_PAGEOUT);
                 if (!pagemap_is_swapped(pagemap_fd, mem)) {
                         ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
                         goto munmap;
                 }
         }
#endif /* MADV_PAGEOUT */

... the above seems like the silver bullet that would catch all cases.

I tend to sometimes OCD on detail and lose the big picture. That's why "the war is
made by multitude of counselors".

I am not territorial about any of my patches, so what the community thinks its the
best ... This is not my day job, but a pet project, and I like the way it makes my
brain tick. :-)

I hope the Author of my story will make up for the years the locust had eaten.

Regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
