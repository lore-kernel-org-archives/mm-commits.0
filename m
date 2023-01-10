Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18631C46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 15:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbjAJPH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 10:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbjAJPHF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 10:07:05 -0500
X-Greylist: delayed 2529 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Jan 2023 07:06:41 PST
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4084C87285
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 07:06:40 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 9554D604F2;
        Tue, 10 Jan 2023 16:06:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673363199; bh=NO65c5+G8bSwPMz9kwwjp8iV+11euOuTibVPMgJ3j+E=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=HFiXg3yv7zibOD9KIioasTD+tZcY/mnSISJAsj9bTPy1s0evO6QaM9TA9W6YT9ywx
         MK5TeYaOldtua1xt67x5g66swAsm76T9GgGKbiIvdeY5RaWUsIuw6LDaezucD13HLe
         /IpteWTzahPSY531DfEid+Fgd+SCUCbvOV51KnopJVsh/AI1lnebXXR/b7Zj6RBRzV
         J9yJsnFBuVXYaH48sS5g7c/hTUKiaGZr6lQqeyfAUI4x4PTpVWvTh0uqDLDlkHampE
         TLGuKsB+RfcT1mBkwStrjZQZHzTLCOcyg1dwV8XhlucjI1mIOgvqBIHrL+cCpoaLIz
         6yqDCaogUXVNQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y9XeFWHKqScr; Tue, 10 Jan 2023 16:06:37 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id 0A377604F1;
        Tue, 10 Jan 2023 16:06:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673363197; bh=NO65c5+G8bSwPMz9kwwjp8iV+11euOuTibVPMgJ3j+E=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=SoxY3LJlYQwRXAqQz63UhmHjcn3M6x7tyI6MMmKvldn/d8hSGeR2ADsXYabwULS4d
         OskqL2Xj9Ys9zxd23TekADwWW+H8pE1mH8yqfhuJRQ8bdJhjmvh7PZw64xrKZAWLRX
         A4k3o6hRuRA1iFHvftt/GbT+kEC/W4u2ZlAhyMFsd8VjqEiO/FfgQVGX26Kx1yexK8
         upM1viNyEBK092rk7id6zmq956ebwl1juozxI+l7WgO6mjv0LQQZhkeMUfLtnZcf5H
         FoUKm6p+ym9KV6xyW20VtcFJZ51Zxxpv15tnbmg0BDIjj0gOH2MQLVN6FYmEL37Zaj
         8RToRgo6rzK1A==
Message-ID: <edcd1c84-9cee-a507-21df-039f3379fa4a@alu.unizg.hr>
Date:   Tue, 10 Jan 2023 16:06:36 +0100
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
 <01aa2810-68c9-c17e-850e-c0a141e462f5@alu.unizg.hr>
 <286bd85a-6dfe-1390-8734-6b11594fc7de@redhat.com>
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <286bd85a-6dfe-1390-8734-6b11594fc7de@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 1/10/23 15:28, David Hildenbrand wrote:
> On 10.01.23 15:24, Mirsad Todorovac wrote:
>> On 1/10/23 15:04, David Hildenbrand wrote:
>>>>
>>>> Of course, we can easily test with "gcc -E" what exactly gets included.
>>>>
>>>> We don't seem to have a uniform way of handling MADV_PAGEOUT and
>>>> MADV_POPULATE(READ|WRITE) even within different C sources within
>>>> tools/testing/selftests/vm itself, so it means that we spread the spectrum
>>>> of systems and compilations that we will break. :-/
>>>>
>>>> To repeat what is obvious, I am not an authority on the Linux kernel,
>>>> but as I said, I have the benefit of a fresh perspective ...
>>>>
>>>> There was an open source proverb that "more eyes see more" :)
>>>
>>> The thing is: I don't lose sleeps about defines that will never change as long as it compiles. That's the most important part (for
>>> me) with these tests. Even if it would change, and I don't see how, we'd get test failures and could fix it up.
>>>
>>> ... and I raised that I ran into issues with what you propose. That's really all I am saying :)
>>>
>>> And to repeat what I said: If we can find a cleanup for all these relevant "ifndef" in selftests/mm I'd be very happy. As long as it
>>> compiles I'm all for cleanups. It would also be acceptable to say "what David tested was wrong" -- but that needs clear 
>>> justification.
>>
>> Then I rest my case.
>>
>> Just to assert:
>>
>> Probably if MADV_PAGEOUT or MADV_POPULATE_(READ|WRITE) isn't defined in in-tree
>> includes, then also the kernel wouldn't support them.
>>
>> #include <sys/mman.h>
>> #include <linux/mman.h>
>>
>> #ifdef MADV_PAGEOUT
>>           if (swapout) {
>>                   madvise(mem, pagesize, MADV_PAGEOUT);
>>                   if (!pagemap_is_swapped(pagemap_fd, mem)) {
>>                           ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
>>                           goto munmap;
>>                   }
>>           }
>> #endif /* MADV_PAGEOUT */
>>
>> ... the above seems like the silver bullet that would catch all cases.
> 
> That wouldn't have allowed me to run the tests properly in the crazy sparc64 environment, where the kernel is new but the headers 
> are old :)

Didn't see that one coming :-/

I don't have a sparc64 box available for testing. Or at all.

>> I tend to sometimes OCD on detail and lose the big picture. That's why "the war is
>> made by multitude of counselors".
>>
>> I am not territorial about any of my patches, so what the community thinks its the
>> best ... This is not my day job, but a pet project, and I like the way it makes my
>> brain tick. :-)
>>
> 
> Again, I'd be very happy if we could just get the in-kernel headers considered properly. But I gave up on that and decided for the 
> "easy" fixes.

Actually, I admire your work on THP and I won't use more of your time in vain.

Just to remind you of the advice Yitro gave to Moses: "Don't judge 2,000,000 people by
yourself - delegate some less important work!" :-)

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
