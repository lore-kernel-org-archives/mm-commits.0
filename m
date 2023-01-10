Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4960C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 16:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbjAJQVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbjAJQVA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 11:21:00 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D175DAB
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 08:20:56 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 28CCC604F1;
        Tue, 10 Jan 2023 17:20:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673367654; bh=UrPMUm69T7wUSe46mW3bgef18qiioylJL5BZ0MVVYIc=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=biWHKs0LdV80AhvW0aIF65GQXMLMzQIflmLU//UY+Y9RSzSkcOGb4pgJoz7ZdZwDJ
         Jr1grBomifBhyvFNpdQhbbkuL0egVOyBdTN3JeVYDIz/aODMIB19wAnIuvYypw5OEf
         kpgVeIC8ZA+uDNKgCpSRUxNUexk2jjmV/YxwJd9kkKYjKXXIcI89k/1c4HYAOwhDKS
         WoUy8naMXBq6h2kDZ/gR5nn7I/LZy1UWbmDTaH/Yuu5crRiHTTkw+mL+ID679f8MTc
         vDH26tL5BGR4QNe+NVpOLHkluUR4G8yUoh1ve703V1Xu4fQevJz4HQMMfPyeyVLo6c
         ES4Lx12MsJ6/g==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M9ozl9OCgA4E; Tue, 10 Jan 2023 17:20:51 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id E7B7A604F0;
        Tue, 10 Jan 2023 17:20:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673367651; bh=UrPMUm69T7wUSe46mW3bgef18qiioylJL5BZ0MVVYIc=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=ppJGrodNmMgtdlsrNZswgM+sAFZc4ovnXmv7ordeWFXfdeZIyOu9QZm4LjKyVFJct
         Y77iu7kQD7gYP7tcRD3W9oPTvTz/hJkgBPk14a5oKHTR00xfUVTfwMmOl7+W+rKqKA
         lcZTc6wuB5ghPtvLO9jY5XNDDZjh/gtfET+1NPdBxIFViIusN17uz8VEEVzwymz8Mg
         +wAByrwShv6/dAymIHFK0NQEHE7ghog0xorTQqQFnEZ0sVhFx+v7pdfnFRJzCr5/uA
         N67OkRP28kS2CcxUmOSihNUodxLZ/uUG5mriQM8IKlaHlB1ZZYF5prec/ij4NfzkgL
         sPKp3FFtxh4Fg==
Message-ID: <36a3bc6a-d863-4234-60b7-a9f55215cfcc@alu.unizg.hr>
Date:   Tue, 10 Jan 2023 17:20:50 +0100
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
 <edcd1c84-9cee-a507-21df-039f3379fa4a@alu.unizg.hr>
 <cfead557-970f-90a8-1184-f4125645bad4@redhat.com>
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <cfead557-970f-90a8-1184-f4125645bad4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 1/10/23 16:43, David Hildenbrand wrote:
> On 10.01.23 16:06, Mirsad Todorovac wrote:
>> On 1/10/23 15:28, David Hildenbrand wrote:
>>> On 10.01.23 15:24, Mirsad Todorovac wrote:
>>>> On 1/10/23 15:04, David Hildenbrand wrote:
>>>>>>
>>>>>> Of course, we can easily test with "gcc -E" what exactly gets included.
>>>>>>
>>>>>> We don't seem to have a uniform way of handling MADV_PAGEOUT and
>>>>>> MADV_POPULATE(READ|WRITE) even within different C sources within
>>>>>> tools/testing/selftests/vm itself, so it means that we spread the spectrum
>>>>>> of systems and compilations that we will break. :-/
>>>>>>
>>>>>> To repeat what is obvious, I am not an authority on the Linux kernel,
>>>>>> but as I said, I have the benefit of a fresh perspective ...
>>>>>>
>>>>>> There was an open source proverb that "more eyes see more" :)
>>>>>
>>>>> The thing is: I don't lose sleeps about defines that will never change as long as it compiles. That's the most important part (for
>>>>> me) with these tests. Even if it would change, and I don't see how, we'd get test failures and could fix it up.
>>>>>
>>>>> ... and I raised that I ran into issues with what you propose. That's really all I am saying :)
>>>>>
>>>>> And to repeat what I said: If we can find a cleanup for all these relevant "ifndef" in selftests/mm I'd be very happy. As long 
>>>>> as it
>>>>> compiles I'm all for cleanups. It would also be acceptable to say "what David tested was wrong" -- but that needs clear
>>>>> justification.
>>>>
>>>> Then I rest my case.
>>>>
>>>> Just to assert:
>>>>
>>>> Probably if MADV_PAGEOUT or MADV_POPULATE_(READ|WRITE) isn't defined in in-tree
>>>> includes, then also the kernel wouldn't support them.
>>>>
>>>> #include <sys/mman.h>
>>>> #include <linux/mman.h>
>>>>
>>>> #ifdef MADV_PAGEOUT
>>>>            if (swapout) {
>>>>                    madvise(mem, pagesize, MADV_PAGEOUT);
>>>>                    if (!pagemap_is_swapped(pagemap_fd, mem)) {
>>>>                            ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
>>>>                            goto munmap;
>>>>                    }
>>>>            }
>>>> #endif /* MADV_PAGEOUT */
>>>>
>>>> ... the above seems like the silver bullet that would catch all cases.
>>>
>>> That wouldn't have allowed me to run the tests properly in the crazy sparc64 environment, where the kernel is new but the headers
>>> are old :)
>>
>> Didn't see that one coming :-/
>>
>> I don't have a sparc64 box available for testing. Or at all.
> 
> Me neither, I was using a qemu-system-sparc64 to test some of my adventurous changes like :
> 
> https://lkml.kernel.org/r/20221212130213.136267-1-david@redhat.com
> 
> and
> 
> https://lkml.kernel.org/r/20221206144730.163732-1-david@redhat.com

This requires time to analyse. I am not into sparc assembly since about the 2000s.

>>>> I tend to sometimes OCD on detail and lose the big picture. That's why "the war is
>>>> made by multitude of counselors".
>>>>
>>>> I am not territorial about any of my patches, so what the community thinks its the
>>>> best ... This is not my day job, but a pet project, and I like the way it makes my
>>>> brain tick. :-)
>>>>
>>>
>>> Again, I'd be very happy if we could just get the in-kernel headers considered properly. But I gave up on that and decided for the
>>> "easy" fixes.
>>
>> Actually, I admire your work on THP and I won't use more of your time in vain.
> 
> I appreciate your review :)

Don't mention it :)

>> Just to remind you of the advice Yitro gave to Moses: "Don't judge 2,000,000 people by
>> yourself - delegate some less important work!" :-)
> 
> so ... you're going to make it work with the in-tree kernel headers? :P

I would that challenging, if the task offer stands. :)

Of course, as of original author, you will always have the last word.

Having done some homework, I understood that you are actually doing the VM work
in the kernel proper, so naturally it would be prudent to appreciate your insight.

With the Linux kernel, just when I thought you have gained some knowledge, I
see that I know virtually nothing :-/

Thanks,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
